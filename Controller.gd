extends Node2D

var flag_player1_alive = false
var flag_player2_alive = false
var rocket_p1
var rocket_p2

# variaveis para o placar
var deaths_list = [0,0,0,0,0,0,0,0]
var kills_list = [0,0,0,0,0,0,0,0]

# lista de nodes que vao para a batalha
var fighters_list = []

const rocket = preload("res://rocket/Rocket.tscn")
const battle_node = preload("res://button_batte/ButtonBattle.tscn")

onready var level = get_node("/root/sandbox")

signal starting_battle_controller(starter)

func _ready():
	pass # Replace with function body.


func _process(delta):
	# Se nao existe o jogador, entao cria
	if Input.is_action_just_pressed("player1") and !flag_player1_alive:
		create_player("player1")
	if Input.is_action_just_pressed("player2") and !flag_player2_alive:
		create_player("player2")
		
	if len(fighters_list) >= 2:
		print('fighters_list:', fighters_list)
		var battle = battle_node.instance()
		battle.fighter_1 = fighters_list[0]
		battle.fighter_2 = fighters_list[1]
		level.add_child(battle)
		fighters_list.pop_back()
		fighters_list.pop_back()
		print('fighters_list:', fighters_list)
		
func create_player(player):
	var rocket_created = rocket.instance()
	rocket_created.player = player
	if player == "player1":
		flag_player1_alive = true
	elif player == "player2":
		flag_player2_alive = true
	level.add_child(rocket_created)

func get_rocket_deaths(player_dead):
	#print('EXPLOSION: ', player_explosion, ' morreu')	# DEBUG
	if player_dead == 'player1':
		flag_player1_alive = false
		deaths_list[0] = deaths_list[0] + 1
	elif player_dead == 'player2':
		flag_player2_alive = false
		deaths_list[1] = deaths_list[1] + 1
	else:
		#print('player explosion error')	# DEBUG
		pass
	
	debug_placar()

func get_rocket_kill(killer):
	if killer == "player1":
		kills_list[0] = kills_list[0] + 1
	elif killer == "player2":
		kills_list[1] = kills_list[1] + 1
		
func create_fighter(fighter):
	fighters_list.append(fighter)
	
	
func debug_placar():
	print('--------------------------------')
	print('## PLACAR ##')
	print('player 1 - K: ', kills_list[0],' / D: ', deaths_list[0])
	print('player 2 - K: ', kills_list[1],' / D: ', deaths_list[1])
