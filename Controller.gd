extends Node2D

var flag_player1_alive = false
var flag_player2_alive = false
var score_player1 = 0
var score_player2 = 0
var rocket_p1
var rocket_p2

const rocket = preload("res://rocket/Rocket.tscn")

onready var level = get_node("/root/sandbox")

func _ready():
	pass # Replace with function body.


func _process(delta):
	# Se nao existe o jogador, entao cria
	if Input.is_action_just_pressed("player1") and !flag_player1_alive:
		create_player("player1")
	if Input.is_action_just_pressed("player2") and !flag_player2_alive:
		create_player("player2")
		
func create_player(player):
	var rocket_created = rocket.instance()
	rocket_created.player = player
	if player == "player1":
		flag_player1_alive = true
	elif player == "player2":
		flag_player2_alive = true
	level.add_child(rocket_created)

func get_rocket_explosions(player_explosion):
	print('EXPLOSION: ', player_explosion, ' morreu')
	if player_explosion == 'player1':
		flag_player1_alive = false
	elif player_explosion == 'player2':
		flag_player2_alive = false
	else:
		print('player explosion error')
