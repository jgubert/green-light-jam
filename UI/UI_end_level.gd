extends Control


var champion_text = ''

onready var label = $CenterContainer/Panel/VSplitContainer/Label
onready var controller = get_node("/root/sandbox/Controller")
onready var restart_bt = $CenterContainer/Panel/VSplitContainer/Button
onready var main_menu_bt = $CenterContainer/Panel/VSplitContainer/Back

signal restart_game


# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(champion_text)
	connect('restart_game', controller, 'restart_game')

func _on_Button_pressed():
	emit_signal('restart_game')
	queue_free()

func _on_Back_pressed():
	get_tree().change_scene("res://UI/StartMenu.tscn")

func _on_Button_mouse_entered():
	restart_bt.grab_focus()

func _on_Button_mouse_exited():
	restart_bt.release_focus()

func _on_Back_mouse_entered():
	main_menu_bt.grab_focus()

func _on_Back_mouse_exited():
	main_menu_bt.release_focus()
