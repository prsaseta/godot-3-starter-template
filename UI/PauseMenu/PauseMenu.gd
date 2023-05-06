extends PanelContainer

signal pause_menu_opened
signal pause_menu_closed

onready var cancel_button_settings = $OptionsMenu.cancel_button
onready var options_menu = $OptionsMenu
onready var pause_container = $PauseVBoxContainer

func _ready():
	cancel_button_settings.connect("button_down", self, "close_settings")
	visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		if visible and options_menu.visible:
			options_menu.close_menu()
			pause_container.visible = true
		else:
			toggle_pause_menu()

func toggle_pause_menu():
	visible = !visible
	options_menu.visible = false
	pause_container.visible = true
	
	if visible:
		emit_signal("pause_menu_opened")
		GPause.add_source("pause_menu")
	else:
		emit_signal("pause_menu_closed")
		GPause.remove_source("pause_menu")

func close_settings():
	options_menu.close_menu()
	pause_container.visible = true

func _on_Continue_button_down():
	toggle_pause_menu()

func _on_Options_button_down(): 
	pause_container.visible = false
	options_menu.open_menu()

func _on_Exit_desktop_button_down():
	get_tree().quit()
