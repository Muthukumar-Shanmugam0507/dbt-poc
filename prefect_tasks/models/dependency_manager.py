import logging

from .dependency_graph import DependencyGraph
from .dependency_node import DependencyNode
from prefect_tasks.utils import trigger_snapshot_flow, trigger_test_flow, trigger_run_flow
from logging import getLogger


class DependencyManager:
    """
    Class responsible for managing the dependency graph and dependency nodes

    Functions:
        generate_dependency_graph: Generates the dependency graph
        get_dependencies: Returns a list of dependencies for a mart
        run_mart: Runs a mart and its dependencies
        get_all_marts: Returns a list of all unique marts in run order
        run_all_marts: Runs all unique marts in order
        dry_run: Prints the functions that would be called in a normal run
    """

    def __init__(self):
        self.dependency_graph = self.generate_dependency_graph()
        self.logger = getLogger(__name__)
        self.logger.setLevel(logging.INFO)

    def _add_active_nodes(self, mart_location, prefix, mart):
        daily = f"{mart_location}.{prefix}_daily_active_{mart}"
        snapshot = f"snapshot_{prefix}_active_{mart}"
        active = f"{mart_location}.{prefix}_active_{mart}"
        daily_node = DependencyNode(daily)
        snapshot_node = DependencyNode(snapshot, [daily_node])
        active_node = DependencyNode(active, [snapshot_node])
        return active_node

    def generate_dependency_graph(self):
        """
        Create dependency graph from dependency nodes

        Nodes:
            assert_models_are_updated
            fbb.fbb_active_products
            fbb.fbb_active_styles
            fbb.fbb_active_variations
            fbb.fbb_daily_products
            marketplace.mp_active_products
            marketplace.mp_active_styles
            marketplace.mp_active_variations
            marketplace.mp_daily_products
            product_sets.fbb_active_product_sets
            special_product_sets.fbb_active_special_product_sets
            slices.fbb_active_slices
            slices.mp_active_slices
            miles.miles_mp_products
            miles.miles_mp_styles
            miles.miles_category_products
            miles.miles_product_sites
            miles.miles_special_product_sets
            miles.miles_fbb_styles
            miles.miles_fbb_products
            miles.miles_product_sets
            miles.miles_active_web_categories
            attribution.kobe_product_level_attributes
            attribution.ds_taxonomy_inference_data
            attribution.kobe_website_product_level_attributes
            gift_cards.fbb_active_gift_card_styles
            gift_cards.fbb_active_gift_cards
            gift_cards.fbb_daily_active_gift_card_styles
            gift_cards.fbb_daily_active_gift_cards
        """
        mart_dependencies = DependencyGraph()
        daily_active_sequence = {
            "fbb": {"fbb": ["variations", "styles", "products"]},
            "marketplace": {"mp": ["variations", "styles", "products"]},
            "slices": {"fbb": ["slices"], "mp": ["slices"]},
            "product_sets": {"fbb": ["product_sets"]},
            "special_product_sets": {"fbb": ["special_product_sets"]},
            "gift_cards": {"fbb": ["gift_card_styles", "gift_cards"]},
        }

        validations = DependencyNode("fbb.fbb_failed_model_updates",
                                     [DependencyNode("fbb.fbb_info_schema"), DependencyNode("fbb.fbb_info_schema_history")])
        mart_dependencies.add_node(DependencyNode("assert_models_are_updated", validations))

        # Adding FBB, Marketplace, FBB Slices, Marketplace Slices, Product Set, Special Product Set and Gift Card nodes
        # with daily active - snapshot - active sequence
        for mart_location, prefixes in daily_active_sequence.items():
            for prefix, marts in prefixes.items():
                for mart in marts:
                    mart_dependencies.add_node(self._add_active_nodes(mart_location, prefix, mart))

        miles_mp_styles = DependencyNode("miles.miles_mp_styles",
                                         [mart_dependencies.nodes["marketplace.mp_active_styles"]])
        mart_dependencies.add_node(miles_mp_styles)

        miles_mp_products = DependencyNode("miles.miles_mp_products", [
            mart_dependencies.nodes["miles.miles_mp_styles"],
            mart_dependencies.nodes["marketplace.mp_active_products"]
        ])
        mart_dependencies.add_node(miles_mp_products)

        miles_category_products = DependencyNode("miles.miles_category_products", [
            mart_dependencies.nodes["fbb.fbb_active_products"],
            mart_dependencies.nodes["marketplace.mp_active_products"],
            mart_dependencies.nodes["product_sets.fbb_active_product_sets"],
            mart_dependencies.nodes["special_product_sets.fbb_active_special_product_sets"],
            mart_dependencies.nodes["slices.fbb_active_slices"]
        ])
        mart_dependencies.add_node(miles_category_products)

        miles_product_sites = DependencyNode("miles.miles_product_sites",
                                             [mart_dependencies.nodes["miles.miles_category_products"]])
        mart_dependencies.add_node(miles_product_sites)

        miles_sps = DependencyNode("miles.miles_special_product_sets", [
            mart_dependencies.nodes["product_sets.fbb_active_product_sets"],
            mart_dependencies.nodes["fbb.fbb_active_styles"]
        ])
        mart_dependencies.add_node(miles_sps)

        miles_fbb_styles = DependencyNode("miles.miles_fbb_styles", [mart_dependencies.nodes["fbb.fbb_active_styles"]])
        mart_dependencies.add_node(miles_fbb_styles)

        miles_fbb_products = DependencyNode("miles.miles_fbb_products", [
            mart_dependencies.nodes["miles.miles_fbb_styles"],
            mart_dependencies.nodes["fbb.fbb_active_products"]
        ])
        mart_dependencies.add_node(miles_fbb_products)

        miles_ps = DependencyNode("miles.miles_product_sets", [
            mart_dependencies.nodes["product_sets.fbb_active_product_sets"],
            mart_dependencies.nodes["miles.miles_fbb_products"]
        ])
        mart_dependencies.add_node(miles_ps)

        miles_gc = DependencyNode("miles.miles_fbb_gift_cards", [mart_dependencies.nodes["gift_cards.fbb_active_gift_cards"]])
        mart_dependencies.add_node(miles_gc)

        # Active Web Categories
        miles_brands = DependencyNode("miles.miles_brands")
        miles_active_web_categories = DependencyNode("miles.miles_active_web_categories", [
            miles_brands,
            mart_dependencies.nodes["fbb.fbb_active_products"],
            mart_dependencies.nodes["marketplace.mp_active_products"],
            mart_dependencies.nodes["product_sets.fbb_active_product_sets"],
            mart_dependencies.nodes["special_product_sets.fbb_active_special_product_sets"],
            mart_dependencies.nodes["slices.fbb_active_slices"],
            mart_dependencies.nodes["slices.mp_active_slices"]
        ])
        mart_dependencies.add_node(miles_active_web_categories)

        ds_product_attributes = DependencyNode("attribution.ds_product_level_attributes")
        kobe_product_attribution = DependencyNode("attribution.kobe_product_level_attributes", [ds_product_attributes])
        mart_dependencies.add_node(kobe_product_attribution)

        ds_taxonomy_inference_data = DependencyNode("attribution.ds_taxonomy_inference_data", [
            kobe_product_attribution, mart_dependencies.nodes["fbb.fbb_active_products"]
        ])
        mart_dependencies.add_node(ds_taxonomy_inference_data)

        ds_taxonomy_train_data = DependencyNode("attribution.ds_taxonomy_train_data", [kobe_product_attribution])
        mart_dependencies.add_node(ds_taxonomy_train_data)

        kobe_website_product_attributes = DependencyNode("attribution.kobe_website_product_level_attributes",
                                                         [kobe_product_attribution])
        mart_dependencies.add_node(kobe_website_product_attributes)
        kobe_flex_fbb_variants = DependencyNode("kobe_flex_merch.kobe_flex_fbb_variants")
        mart_dependencies.add_node(kobe_flex_fbb_variants)

        return mart_dependencies

    def get_dependencies(self, name: str):
        """ Returns a list of mart dependencies for the specified mart """
        return self.dependency_graph.get_dependencies(name)

    def run_mart(self, name: str):
        """ Runs the dependencies of the specified mart """
        self.dependency_graph.run_dependencies(name)

    def get_all_marts(self):
        """ Gets all mart dependency names exactly once in run order """
        dependency_list = []
        for mart in self.generate_dependency_graph().nodes:
            node_dependencies = self.get_dependencies(mart)
            for node_dependency in node_dependencies:
                if node_dependency not in dependency_list:
                    dependency_list.append(node_dependency)
            dependency_list.append(mart)
        return dependency_list

    def run_all_marts(self):
        """ Runs all mart dependencies exactly once """
        marts = self.get_all_marts()
        for mart in marts:
            if mart.startswith("snapshot"):
                trigger_snapshot_flow(mart)
            elif mart.startswith("assert"):
                trigger_test_flow()
            else:
                trigger_run_flow(mart)

    def dry_run(self):
        """ Prints the prefect flows instead of running them """
        marts = self.get_all_marts()
        for mart in marts:
            if mart.startswith("snapshot"):
                self.logger.info(f"trigger_snapshot_flow({mart})")
            elif mart.startswith("assert"):
                self.logger.info("trigger_test_flow()")
            else:
                self.logger.info(f"trigger_run_flow({mart})")
