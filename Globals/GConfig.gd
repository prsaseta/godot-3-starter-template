extends Node

signal config_changed

##########################
# Constantes
##########################

var resolution_presets: Dictionary = {
	0: Vector2(960,540), 
	1: Vector2(1280,720), 
	2: Vector2(1600,900), 
	3: Vector2(1920,1080), 
	4: Vector2(2560,1440), 
	5: Vector2(3840,2160)
}

var font_size_presets: Dictionary = {
	0: 16,
	1: 24,
	2: 32,
	3: 48,
	4: 64,
}

var big_font_size_presets: Dictionary = {
	0: 32,
	1: 48,
	2: 64,
	3: 96,
	4: 128,
}

const MIN_VOL: float = 0.0
const MAX_VOL: float = 1.0

const CONFIG_PATH: String = "user://config.json"

# Si no encuentra un código de lenguaje, falla a este
const DEFAULT_LOCALE: String = "en"

const FONT_RESOURCES: Array = [
	preload("res://Fonts/BasicUIFont.tres")
]

const BIG_FONT_RESOURCES: Array = [
	preload("res://Fonts/BigUIFont.tres")
]

##########################
# Propiedades privadas
##########################

# Cambiar la resolución no lo actualiza bien en un solo frame,
# volverlo a setear al siguiente lo arregla
var _update_window_frames_left: int = 0

##########################
# Propiedades públicas
##########################

var _resolution_preset: int = 3 setget set_resolution_preset,get_resolution_preset
var _font_size_preset: int = 2 setget set_font_size_preset,get_font_size_preset
var _fullscreen: bool = true setget set_fullscreen,is_fullscreen
var _music_vol: float = 1.0 setget set_music_vol,get_music_vol
var _sfx_vol: float = 1.0 setget set_sfx_vol,get_sfx_vol
var _locale: String = DEFAULT_LOCALE setget set_locale,get_locale

##########################
# _process y _ready
##########################

func _ready():
	# Si los FPS de físicas y de pantalla no coinciden, ocurren efectos
	# de jittering: activar esto si ocurre, desactivarlo si no
	# Arreglado en Godot 4.0, hay un plugin que backportea a Godot 3.x
	# pero crea más bugs de los que soluciona
	Engine.set_target_fps(60)
	load_from_disk()
	
func _process(_delta):
	if _update_window_frames_left > 0:
		_update_window()
		_update_window_frames_left -= 1

##########################
# Gestión de ficheros
##########################

func save_to_disk() -> void:
	var save: Dictionary = {
		"res_preset": _resolution_preset,
		"font_size_preset": _font_size_preset,
		"fullscreen": _fullscreen,
		"music_vol": _music_vol,
		"sfx_vol": _sfx_vol,
		"locale": _locale,
	}
	
	var file: File = File.new()
	file.open(CONFIG_PATH, file.WRITE)
	file.store_string(to_json(save))
	file.close()

func load_from_disk() -> void:
	var file: File = File.new()
	var err: int = file.open(CONFIG_PATH, file.READ)
	# Contenido del fichero de configuración
	var contents
	# Configuración guardada a cargar
	var save: Dictionary
	
	# Si no se carga bien el fichero por cualquier motivo:
	if err != OK:
		print("ERROR LOADING CONFIG FILE: %s \nFalling back to default config." % err)
		save = {}
	else:
		contents = parse_json(file.get_as_text())
		# Si el fichero es un diccionario, todo bien
		if typeof(contents) == TYPE_DICTIONARY:
			save = contents
			print("Config loaded successfully")
		else:
			# Si no es un diccionario, valores por defecto
			save = {}
			print("ERROR IN CONFIG FILE FORMATTING! \nFalling back to default config.")
	
	# Cerramos fichero
	file.close()
	
	# Recuperamos configuración del fichero cargado
	# Si no existe la clave, ponemos un valor por defecto
	set_fullscreen(bool(save.get("fullscreen", true)))
	set_resolution_preset(int(save.get("res_preset", 3)))
	set_font_size_preset(int(save.get("font_size_preset", 2)))
	set_music_vol(float(save.get("music_vol", 1.0)))
	set_sfx_vol(float(save.get("sfx_vol", 1.0)))
	set_locale(String(save.get("locale", TranslationServer.get_locale())))
	
##########################
# Getters/Setters
##########################
	
func get_resolution_preset() -> int:
	return _resolution_preset
	
func set_resolution_preset(pre: int) -> void:
	if not pre in resolution_presets.keys():
		pre = 3
	_resolution_preset = pre
	_update_window_frames_left += 2
	emit_signal("config_changed")
	
func is_fullscreen() -> bool:
	return _fullscreen
	
func set_fullscreen(full: bool) -> void:
	_fullscreen = full
	_update_window_frames_left += 2
	emit_signal("config_changed")
	
func get_music_vol() -> float:
	return _music_vol
	
func set_music_vol(vol: float) -> void:
	_music_vol = clamp(vol, MIN_VOL, MAX_VOL)
	emit_signal("config_changed")
	
func get_sfx_vol() -> float:
	return _sfx_vol
	
func set_sfx_vol(vol: float) -> void:
	_sfx_vol = clamp(vol, MIN_VOL, MAX_VOL)
	emit_signal("config_changed")
	
func set_locale(loc: String) -> void:
	if not loc in TranslationServer.get_loaded_locales():
		loc = DEFAULT_LOCALE
	_locale = loc
	TranslationServer.set_locale(loc)
	emit_signal("config_changed")
	
func get_locale() -> String:
	return _locale
	
func set_font_size_preset(preset: int) -> void:
	if not preset in font_size_presets.keys():
		preset = 2
	_font_size_preset = preset
	
	for font in FONT_RESOURCES:
		font.size = font_size_presets[preset]
		
	for font in BIG_FONT_RESOURCES:
		font.size = big_font_size_presets.get(preset, 64)
		
	emit_signal("config_changed")
	
func get_font_size_preset() -> int:
	return _font_size_preset
	
##########################
# Update
##########################
	
func _update_window() -> void:
	OS.set_window_size(resolution_presets.get(_resolution_preset, Vector2(1920, 1080)))
	OS.set_window_fullscreen(_fullscreen)
	OS.set_borderless_window(false)
