extends Node2D

var fighter_1
var fighter_2

var points_f1 = 5
var points_f2 = 5

signal winner
signal loser

func _ready():
	pass # Replace with function body.



func _process(delta):
	if Input.is_action_just_pressed(fighter_1.player):
		points_f1 = points_f1 + 1
		points_f2 = points_f2 - 1
		print_battle_debug()
	if Input.is_action_just_pressed(fighter_2.player):
		points_f1 = points_f1 - 1
		points_f2 = points_f2 + 1
		print_battle_debug()
	
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
