import logging

from .dependency_node import DependencyNode
from logging import getLogger


class DependencyGraph:
    """
    Custom Data Structure to hold dependency chains

    Fields:
        nodes: A list of DependencyNode objects that can be called for the functions

    Functions:
        add_node: Add a dependency node to the graph
        get_dependencies: Get all dependencies for a node (excluding node)
        run_dependencies: Run all dependencies for a node (including node)
    """
    def __init__(self):
        self.nodes = {}
        self.logger = getLogger(__name__)
        self.logger.setLevel(logging.INFO)

    def add_node(self, node: DependencyNode):
        """ Add a dependency node to the graph """
        self.nodes[node.name] = node

    def get_dependencies(self, name: str):
        """ Get all dependencies for the specified node """
        if name in self.nodes:
            node = self.nodes[name]
            return node.get_node_dependencies()
        else:
            self.logger.info(f"No node found with the name: {name}")
            return []

    def run_dependencies(self, name: str):
        """ Run all dependencies for the specified node """
        if name in self.nodes:
            node = self.nodes[name]
            self.logger.info(node.name)
            node.run_dependencies()
        else:
            self.logger.info(f"No node found with the name: {name}")
