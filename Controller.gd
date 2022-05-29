extends Node2D

var flag_player1_created = false
var flag_player2_created = false
var score_player1 = 0
var score_player2 = 0

const player1 = preload("res://rocket/Rocket.tscn")
const player2 = preload("res://rocket-player2/Rocket_p2.tscn")

onready var level = get_node("/root/sandbox")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Depois trocar esse teste por sinais nas colisoes
	if level.get_node_or_null('Rocket') == null:
		flag_player1_created = false
	else:
		flag_player1_created = true
	if level.get_node_or_null('Rocket_p2') == null:
		flag_player2_created = false
	else:
		flag_player2_created = true
	
	# Se nao existe o jogador, entao cria
	if Input.is_action_just_pressed("player1") and !flag_player1_created:
		level.add_child(player1.instance())
	if Input.is_action_just_pressed("player2") and !flag_player2_created:
		level.add_child(player2.instance())
