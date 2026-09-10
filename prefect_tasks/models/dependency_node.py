import logging

from prefect_tasks.utils import trigger_run_flow, trigger_snapshot_flow, trigger_test_flow
from logging import getLogger


class DependencyNode:
    """
    Class representing a dependency node

    Functions:
        add_dependency: Adds a dependency to the node
        print_node_dependencies: Prints the dependencies of the node
        run_dependencies: Runs the dependencies of the node (including node)
        get_node_dependencies: Returns a list of the node's dependencies
    """
    def __init__(self, name: str, previous=None):
        self.name = name
        self.previous = previous if previous else []
        self.logger = getLogger(__name__)
        self.logger.setLevel(logging.INFO)

    def add_dependency(self, node):
        """ Adds a dependency to the node """
        self.previous.append(node)

    def print_node_dependencies(self):
        """ Prints the dependencies of the node """
        dependencies = self.get_node_dependencies()[::-1]
        for mart in dependencies:
            self.logger.info(mart)

    def run_dependencies(self):
        """ Runs the dependencies of the node (including node) """
        for node in self.previous:
            node.run_dependencies()
        if self.name.startswith("snapshot"):
            trigger_snapshot_flow(self.name)
        elif self.name.startswith("assert"):
            trigger_test_flow()
        else:
            trigger_run_flow(self.name)

    def get_node_dependencies(self, collected=None):
        """ Returns a list of the node's dependencies """
        if collected is None:
            collected = []
        for node in self.previous:
            if node not in collected:
                collected.insert(0, node.name)
            node.get_node_dependencies(collected)
        return collected

    def __iter__(self):
        for node in self.previous:
            yield from node
        yield self

    def __str__(self):
        return f'{self.name}'
