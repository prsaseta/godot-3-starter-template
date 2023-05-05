extends Node

# Se encarga de gestionar fuentes de pausa, tal que p.e. puedas abrir el
# menú de pausa mientras estás en otro menú que pausa el juego sin que
# al salir del menú de pausa se despause todo

# Array de String
# Todas las fuentes de pausa
var _sources: Array = []

func add_source(source: String) -> void:
	if not source in _sources:
		_sources.append(source)
	get_tree().paused = len(_sources) > 0
	
func remove_source(source: String) -> void:
	if source in _sources:
		_sources.erase(source)
	get_tree().paused = len(_sources) > 0
