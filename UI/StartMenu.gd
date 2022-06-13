extends Control

onready var start_button = $VSplitContainer/Start
onready var settings_button = $VSplitContainer/Settings
onready var exit_button = $VSplitContainer/Exit

func _on_Start_pressed():
	get_tree().change_scene("res://sandbox.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://UI/MenuControles.tscn")
	
func _on_Exit_pressed():
	get_tree().quit()


func _on_Start_mouse_entered():
	start_button.grab_focus()

func _on_Start_mouse_exited():
	start_button.release_focus()

func _on_Settings_mouse_entered():
	settings_button.grab_focus()

func _on_Settings_mouse_exited():
	settings_button.release_focus()

func _on_Exit_mouse_entered():
	exit_button.grab_focus()

func _on_Exit_mouse_exited():
	exit_button.release_focus()
