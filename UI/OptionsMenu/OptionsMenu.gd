extends PanelContainer

onready var locale_option: OptionButton = $VBC/SettingsSC/SettingsVBC/LocaleHBC/LocaleOB
onready var resolution_option: OptionButton = $VBC/SettingsSC/SettingsVBC/ResolutionHBC/ResolutionOB
onready var font_size_option: OptionButton = $VBC/SettingsSC/SettingsVBC/FontSizeHBC/FontSizeOB
onready var fullscreen_cb: CheckBox = $VBC/SettingsSC/SettingsVBC/FullscreenHBC/FullscreenCB
onready var music_slider: HSlider = $VBC/SettingsSC/SettingsVBC/MusicHBC/MusicHS
onready var music_label: Label = $VBC/SettingsSC/SettingsVBC/MusicHBC/MusicLabel
onready var sfx_slider: HSlider = $VBC/SettingsSC/SettingsVBC/SFXHBC/SFXHS
onready var sfx_label: Label = $VBC/SettingsSC/SettingsVBC/SFXHBC/SFXLabel

onready var cancel_button: Button = $"%CancelButton"

var _locale_ids: Dictionary = {}

func _ready():
	_update_menu()
	
func open_menu() -> void:
	visible = true
	_update_menu()
	
func close_menu() -> void:
	visible = false

func _update_menu() -> void:
	fullscreen_cb.pressed = GConfig.is_fullscreen()
	
	music_slider.min_value = GConfig.MIN_VOL
	music_slider.max_value = GConfig.MAX_VOL
	music_slider.step = 0.01
	music_slider.value = GConfig.get_music_vol()
	
	sfx_slider.min_value = GConfig.MIN_VOL
	sfx_slider.max_value = GConfig.MAX_VOL
	sfx_slider.step = 0.01
	sfx_slider.value = GConfig.get_sfx_vol()
	
	locale_option.clear()
	_locale_ids = {}
	var _selected_locale: int = 0
	for i in range(len(TranslationServer.get_loaded_locales())):
		var locale: String = TranslationServer.get_loaded_locales()[i]
		locale_option.add_item(TranslationServer.get_locale_name(locale), i)
		_locale_ids[i] = locale
		if locale == GConfig.get_locale():
			_selected_locale = i
	locale_option.select(_selected_locale)
		
	resolution_option.clear()
	var _selected_res: int = 3
	for i in range(len(GConfig.resolution_presets.keys())):
		var preset: Vector2 = GConfig.resolution_presets[i]
		resolution_option.add_item("%sx%s" % [preset.x,preset.y], i)
		if GConfig.get_resolution_preset() == i:
			_selected_res = i
	resolution_option.select(_selected_res)
	
	font_size_option.clear()
	var _selected_font_size: int = 2
	for i in range(len(GConfig.font_size_presets.keys())):
		var preset: int = GConfig.font_size_presets[i]
		font_size_option.add_item(str(preset), i)
		if GConfig.get_font_size_preset() == i:
			_selected_font_size = i
	font_size_option.select(_selected_font_size)


func _apply_options() -> void:
	GConfig.set_locale(_locale_ids[locale_option.get_selected_id()])
	GConfig.set_resolution_preset(resolution_option.get_selected_id())
	GConfig.set_font_size_preset(font_size_option.get_selected_id())
	GConfig.set_fullscreen(fullscreen_cb.pressed)
	GConfig.set_sfx_vol(sfx_slider.value)
	GConfig.set_music_vol(music_slider.value)
	
	GConfig.save_to_disk()

func _on_ApplyButton_pressed():
	_apply_options()


func _on_MusicHS_value_changed(value):
	music_label.text = str(value * 100) + "%"


func _on_SFXHS_value_changed(value):
	sfx_label.text = str(value * 100) + "%"
