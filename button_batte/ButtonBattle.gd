extends Node2D

var fighter_1
var fighter_2

var points_f1 = 5
var points_f2 = 5

signal winner
signal loser

onready var canvas = $CanvasLayer
onready var battle_bar = $CanvasLayer/ProgressBar

func _ready():
	battle_bar.set_global_position(Vector2(fighter_1.position.x - 35, fighter_1.position.y - 35))
	# Ajusta o jogador de acordo com a posição
	if fighter_1.position.x > fighter_2.position.x:
		var fighter_aux = fighter_1
		fighter_1 = fighter_2
		fighter_2 = fighter_aux

func _process(delta):
	if !is_instance_valid(fighter_1) and !is_instance_valid(fighter_2):
		queue_free()
	elif !is_instance_valid(fighter_1):
		fighter_2.back_to_idle()
		queue_free()
	elif !is_instance_valid(fighter_2):
		fighter_1.back_to_idle()
		queue_free()
	battle_bar.value = points_f1
	
	if is_instance_valid(fighter_1):
		if Input.is_action_just_pressed(fighter_1.player):
			points_f1 = points_f1 + 1
			points_f2 = points_f2 - 1
			#print_battle_debug()
	if is_instance_valid(fighter_2):
		if Input.is_action_just_pressed(fighter_2.player):
			points_f1 = points_f1 - 1
			points_f2 = points_f2 + 1
			#print_battle_debug()
	
	if points_f1 == 0:
		connect("loser",fighter_1, "result_battle", ["lose"])
		connect("winner",fighter_2, "result_battle", ["win"])
		emit_signal("loser")
		emit_signal("winner")
		queue_free()
	elif points_f2 == 0:
		connect("loser",fighter_2, "result_battle", ["lose"])
		connect("winner",fighter_1, "result_battle", ["win"])
		emit_signal("loser")
		emit_signal("winner")
		queue_free()

func print_battle_debug():
	print('-----------------------')
	print('## BATTLE ##')
	print(fighter_1.player, ' : ', points_f1)
	print(fighter_2.player, ' : ', points_f2)

func _on_Timer_timeout():
	if points_f1 > points_f2:
		connect("loser",fighter_1, "result_battle", ["lose"])
		connect("winner",fighter_2, "result_battle", ["win"])
		emit_signal("loser")
		emit_signal("winner")
		queue_free()
	elif points_f2 > points_f1:
		connect("loser",fighter_2, "result_battle", ["lose"])
		connect("winner",fighter_1, "result_battle", ["win"])
		emit_signal("loser")
		emit_signal("winner")
		queue_free()
	else:
		connect("loser",fighter_1, "result_battle", ["lose"])
		connect("loser",fighter_2, "result_battle", ["lose"])
		emit_signal("loser")
		queue_free()
