extends Node

# Clase que gestiona las variables persistentes de la partida

############################
# Señales
############################

# Emitida cuando se cambia el valor de una variable numérica
signal numeric_var_updated(varname, varvalue)
# Emitida cuando se cambia el valor de una variable de cadena
signal string_var_updated(varname, varvalue)
# Emitida cuando se reinicia el estado
signal reset
# Emitida cuando se carga el estado
signal loaded

############################
# Propiedades privadas
############################

# Variables en formato float
var _game_float_variables: Dictionary = {
	
}

# Variables en formato String
var _game_string_variables: Dictionary = {
	
}

############################
# Banderas y constantes
############################

# Persiste a disco las variables en cuanto se cambien
const AUTOSAVE: bool = true

# Recupera de disco las variables en cuanto arranque el juego
const AUTOLOAD: bool = true

# Fichero donde se van a guardar/cargar los datos
const SAVE_PATH: String = "user://save.json"

const FLOAT_VARS_FILE_PROPERTY: String = "float_vars"
const STRING_VARS_FILE_PROPERTY: String = "string_vars"

# Si hay cambios sin persistir
var dirty: bool = false

##############################
# Manipulación de variables
##############################

# Guarda una variable
func set_float_var(varname: String, value: float) -> void:
	_game_float_variables[varname] = value
	dirty = true
	emit_signal("numeric_var_updated", varname, value)
	
# Suma o resta a una variable
func modify_float_var(varname: String, mod: float) -> void:
	set_float_var(varname, get_float_var(varname) + mod)
	
# Obtén el valor de una variable
# Por defecto, el valor es 0
func get_float_var(varname: String) -> float:
	return _game_float_variables.get(varname, 0.0)
		
# Guarda una variable de cadena
func set_string_var(varname: String, value: String) -> void:
	_game_string_variables[varname] = value
	dirty = true
	emit_signal("string_var_updated", varname, value)
	
# Obtén el valor de una variable de cadena
# Por defecto, el valor es ""
func get_string_var(varname: String) -> String:
	return _game_string_variables.get(varname, "")
		
##############################
# Inicialización y proceso
##############################

func _ready():
	if AUTOLOAD:
		load_from_disc()

func _process(delta):
	if dirty and AUTOSAVE:
		dump_to_disc()

##############################
# Gestión de estado
##############################

# Reinicia las variables
func reset_state() -> void:
	_game_float_variables = {}
	_game_string_variables = {}
	dirty = false
	emit_signal("reset")
	
# Devuelve la información a persistir
func get_save_state() -> Dictionary:
	return {
		FLOAT_VARS_FILE_PROPERTY: _game_float_variables, 
		STRING_VARS_FILE_PROPERTY: _game_string_variables
		}
	
# Restaura el manager a partir de la información persistida
func restore_state_from(vars: Dictionary) -> void:
	reset_state()
	
	var numvars: Dictionary = vars[FLOAT_VARS_FILE_PROPERTY]
	var strvars: Dictionary = vars[STRING_VARS_FILE_PROPERTY]
	
	for key in numvars.keys():
		_game_float_variables[str(key)] = float(numvars[key])
	
	for key in strvars.keys():
		_game_string_variables[str(key)] = str(strvars[key])
	
	dirty = false
	
	emit_signal("loaded")

##############################
# I/O
##############################

# Guarda datos en disco
func dump_to_disc() -> void:
	var file: File = File.new()
	var err: int = file.open(SAVE_PATH, file.WRITE)
	if err != OK:
		print("ERROR SAVING GVARS TO DISC: %s" % err)
		return
	
	file.store_string(to_json(get_save_state()))
	file.close()
	
	dirty = false
	
	print("GVars state saved to %s" % SAVE_PATH)
	
# Recupera datos de disco
func load_from_disc() -> void:
	print("Loading GVars state from %s" % SAVE_PATH)
	
	var file: File = File.new()
	var err: int = file.open(SAVE_PATH, file.READ)
	
	if err != OK:
		print("ERROR LOADING GVARS FROM DISC: %s" % err)
		return
	
	var file_contents = parse_json(file.get_as_text())
	file.close()
	
	if typeof(file_contents) != TYPE_DICTIONARY:
		print("ERROR LOADING GVARS FROM DISC: INVALID FORMAT")
		
	var dict: Dictionary = file_contents
	
	restore_state_from(dict)
