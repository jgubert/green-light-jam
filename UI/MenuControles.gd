extends CanvasLayer

onready var back_button = $Voltar
onready var save_button = $Salvar
onready var button_player1 = $player1/bt_p1
onready var button_player2 = $player2/bt_p2
onready var button_player3 = $player3/bt_p3
onready var button_player4 = $player4/bt_p4
onready var button_player5 = $player5/bt_p5
onready var button_player6 = $player6/bt_p6
onready var button_player7 = $player7/bt_p7
onready var button_player8 = $player8/bt_p8

onready var button_script = load("res://UI/MenuControles_Botao.gd")

var changing_bind = false
var key
var value
var button

var keybinds = {}

func _ready():
	button_player1.key = "player1"
	button_player1.set_text(InputMap.get_action_list("player1")[0].as_text())
	button_player2.key = "player2"
	button_player2.set_text(InputMap.get_action_list("player2")[0].as_text())
	button_player3.key = "player3"
	button_player3.set_text(InputMap.get_action_list("player3")[0].as_text())
	button_player4.key = "player4"
	button_player4.set_text(InputMap.get_action_list("player4")[0].as_text())
	button_player5.key = "player5"
	button_player5.set_text(InputMap.get_action_list("player5")[0].as_text())
	button_player6.key = "player6"
	button_player6.set_text(InputMap.get_action_list("player6")[0].as_text())
	button_player7.key = "player7"
	button_player7.set_text(InputMap.get_action_list("player7")[0].as_text())
	button_player8.key = "player8"
	button_player8.set_text(InputMap.get_action_list("player8")[0].as_text())
	
	keybinds = Global.keybinds
	
func _on_Voltar_pressed():
	get_tree().change_scene("res://UI/StartMenu.tscn")

func _on_Voltar_mouse_entered():
	back_button.grab_focus()

func _on_Voltar_mouse_exited():
	back_button.release_focus()

func _on_bt_p1_mouse_entered():
	button_player1.grab_focus()

func _on_bt_p1_mouse_exited():
	if !button_player1.waiting_input:
		button_player1.release_focus()
	
func _on_bt_p2_mouse_entered():
	button_player2.grab_focus()

func _on_bt_p2_mouse_exited():
	if !button_player2.waiting_input:
		button_player2.release_focus()

func _on_bt_p3_mouse_entered():
	button_player3.grab_focus()

func _on_bt_p3_mouse_exited():
	if !button_player3.waiting_input:
		button_player3.release_focus()

func _on_bt_p4_mouse_entered():
	button_player4.grab_focus()

func _on_bt_p4_mouse_exited():
	if !button_player4.waiting_input:
		button_player4.release_focus()

func _on_bt_p5_mouse_entered():
	button_player5.grab_focus()

func _on_bt_p5_mouse_exited():
	if !button_player5.waiting_input:
		button_player5.release_focus()
	
func _on_bt_p6_mouse_entered():
	button_player6.grab_focus()

func _on_bt_p6_mouse_exited():
	if !button_player6.waiting_input:
		button_player6.release_focus()

func _on_bt_p7_mouse_entered():
	button_player7.grab_focus()

func _on_bt_p7_mouse_exited():
	if !button_player7.waiting_input:
		button_player7.release_focus()

func _on_bt_p8_mouse_entered():
	button_player8.grab_focus()

func _on_bt_p8_mouse_exited():
	if !button_player8.waiting_input:
		button_player8.release_focus()

func _on_Salvar_pressed():
	Global.keybinds = keybinds
	Global.set_game_binds()
	Global.write_config()

func _on_Salvar_mouse_entered():
	save_button.grab_focus()

func _on_Salvar_mouse_exited():
	save_button.release_focus()
