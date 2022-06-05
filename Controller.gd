extends Node2D

# definicoes de tamanho de tela
var screen_limit_x = 640
var screen_limit_y = 360

var flag_player1_alive = false
var flag_player2_alive = false
var rocket_p1
var rocket_p2

# variaveis para o placar
var deaths_list = [0,0,0,0,0,0,0,0]
var kills_list = [0,0,0,0,0,0,0,0]

# lista de nodes que vao para a batalha
var fighters_list = []

enum powerups {
	escudo
}

const rocket = preload("res://rocket/Rocket.tscn")
const battle_node = preload("res://button_batte/ButtonBattle.tscn")
onready var powerup_escudo = preload("res://power_ups/powerup_escudo.tscn")

onready var level = get_node("/root/sandbox")
onready var timer_powerup = get_node("/root/sandbox/Timer_PowerUp")
# variavel armazena o powerup que estiver na tela
var pu_choosed
var choose_powerup

var rng = RandomNumberGenerator.new()

signal starting_battle_controller(starter)

func _ready():
	reset_timer_powerup()

func reset_timer_powerup():
	rng.randomize()
	timer_powerup.set_wait_time(rng.randf_range(10, 15))
	timer_powerup.set_one_shot(true)
	timer_powerup.start()
	print(timer_powerup.get_wait_time())

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

func _on_Timer_PowerUp_timeout():
	choose_powerup = powerups.keys()[randi() % powerups.size()]
	if choose_powerup == "escudo":
		pu_choosed = powerup_escudo.instance()
	# elif ....
	rng.randomize()
	pu_choosed.position = Vector2(
		rng.randf_range(0, screen_limit_x),
		rng.randf_range(0, screen_limit_y)
	)
	level.add_child(pu_choosed)

func pegaram_powerup(player):
	if is_instance_valid(pu_choosed):
		pu_choosed.queue_free()
		if choose_powerup == "escudo":
			var pu_on_player = powerup_escudo.instance()
			pu_on_player.on_player = true
			player.add_child(pu_on_player)
		
		reset_timer_powerup()
	
