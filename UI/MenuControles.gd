extends Control

onready var back_button = $Voltar
func _on_Voltar_pressed():
	get_tree().change_scene("res://UI/StartMenu.tscn")

func _on_Voltar_mouse_entered():
	back_button.grab_focus()

func _on_Voltar_mouse_exited():
	back_button.release_focus()
