extends Reference

# Clase de utilidad para ordenar nodos Node2D en base a la distancia
# a otro Node2D
class_name DistanceSorter

var target: Node2D = null

func sort_by_distance(arg1: Node2D, arg2: Node2D) -> bool:
	var dist1: float = arg1.get_global_position().distance_to(target.get_global_position())
	var dist2: float = arg2.get_global_position().distance_to(target.get_global_position())
	return dist1 <= dist2
