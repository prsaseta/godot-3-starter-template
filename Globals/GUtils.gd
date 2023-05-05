extends Node

# Métodos de utilidad varios

func is_node_valid(node: Node) -> bool:
	return node != null and is_instance_valid(node) and not node.is_queued_for_deletion()
