extends Node2D

# definicoes de tamanho de tela
var screen_limit_x = 640
var screen_limit_y = 360

var flag_player1_alive = false
var flag_player2_alive = false
#var rocket_p1
#var rocket_p2

# variaveis para o placar
var deaths_list = [0,0,0,0,0,0,0,0]
var kills_list = [0,0,0,0,0,0,0,0]
var flag_player_alive = [false, false, false, false, false, false, false, false]

# lista de nodes que vao para a batalha
var fighters_list = []

enum powerups {
	escudo
}

const rocket = preload("res://rocket/Rocket.tscn")
const battle_node = preload("res://button_batte/ButtonBattle.tscn")
onready var powerup_escudo = preload("res://power_ups/powerup_escudo.tscn")
onready var ui_end_level = preload("res://UI/UI_end_level.tscn")

onready var level = get_node("/root/sandbox")
onready var timer_powerup = get_node("/root/sandbox/Timer_PowerUp")
onready var ui = get_node("/root/sandbox/UI_score_e_cronometro")

# variavel armazena o powerup que estiver na tela
var pu_choosed
var choose_powerup

var rng = RandomNumberGenerator.new()
var tempo_level = 60

signal starting_battle_controller(starter)
signal set_ui_timer(tempo)
signal atualiza_placar(deaths_list, kills_list)

func _ready():
	reset_timer_powerup()
	connect("set_ui_timer", ui, "set_tempo_level", [tempo_level])
	emit_signal("set_ui_timer")
	connect("atualiza_placar", ui, "atualiza_placar", [deaths_list, kills_list])

func reset_timer_powerup():
	rng.randomize()
	timer_powerup.set_wait_time(rng.randf_range(10, 15))
	timer_powerup.set_one_shot(true)
	timer_powerup.start()
	#print('Tempo ate proximo powerup: ', timer_powerup.get_wait_time())

func reset_scoreboard():
	kills_list = [0,0,0,0,0,0,0,0]
	deaths_list = [0,0,0,0,0,0,0,0]

func _process(delta):
	# Se nao existe o jogador, entao cria
	if Input.is_action_just_pressed("player1") and !flag_player_alive[0]:
		create_player("player1")
	elif Input.is_action_just_pressed("player2") and !flag_player_alive[1]:
		create_player("player2")
	elif Input.is_action_just_pressed("player3") and !flag_player_alive[2]:
		create_player("player3")
	elif Input.is_action_just_pressed("player4") and !flag_player_alive[3]:
		create_player("player4")
	elif Input.is_action_just_pressed("player5") and !flag_player_alive[4]:
		create_player("player5")
	elif Input.is_action_just_pressed("player6") and !flag_player_alive[5]:
		create_player("player6")
	elif Input.is_action_just_pressed("player7") and !flag_player_alive[6]:
		create_player("player7")
	elif Input.is_action_just_pressed("player8") and !flag_player_alive[7]:
		create_player("player8")
	
		
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
		flag_player_alive[0] = true
	elif player == "player2":
		flag_player_alive[1] = true
	elif player == "player3":
		flag_player_alive[2] = true
	elif player == "player4":
		flag_player_alive[3] = true
	elif player == "player5":
		flag_player_alive[4] = true
	elif player == "player6":
		flag_player_alive[5] = true
	elif player == "player7":
		flag_player_alive[6] = true
	elif player == "player8":
		flag_player_alive[7] = true
	level.add_child(rocket_created)

func get_rocket_deaths(player_dead):
	#print('EXPLOSION: ', player_explosion, ' morreu')	# DEBUG
	if player_dead == 'player1':
		flag_player_alive[0] = false
		deaths_list[0] = deaths_list[0] + 1
	elif player_dead == 'player2':
		flag_player_alive[1] = false
		deaths_list[1] = deaths_list[1] + 1
	elif player_dead == 'player3':
		flag_player_alive[2] = false
		deaths_list[2] = deaths_list[2] + 1
	elif player_dead == 'player4':
		flag_player_alive[3] = false
		deaths_list[3] = deaths_list[3] + 1
	elif player_dead == 'player5':
		flag_player_alive[4] = false
		deaths_list[4] = deaths_list[4] + 1
	elif player_dead == 'player6':
		flag_player_alive[5] = false
		deaths_list[5] = deaths_list[5] + 1
	elif player_dead == 'player7':
		flag_player_alive[6] = false
		deaths_list[6] = deaths_list[6] + 1
	elif player_dead == 'player8':
		flag_player_alive[7] = false
		deaths_list[7] = deaths_list[7] + 1
	else:
		#print('player explosion error')	# DEBUG
		pass
	
	#debug_placar()
	emit_signal("atualiza_placar")

func get_rocket_kill(killer):
	if killer == "player1":
		kills_list[0] = kills_list[0] + 1
	elif killer == "player2":
		kills_list[1] = kills_list[1] + 1
	elif killer == "player3":
		kills_list[2] = kills_list[2] + 1
	elif killer == "player4":
		kills_list[3] = kills_list[3] + 1
	elif killer == "player5":
		kills_list[4] = kills_list[4] + 1
	elif killer == "player6":
		kills_list[5] = kills_list[5] + 1
	elif killer == "player7":
		kills_list[6] = kills_list[6] + 1
	elif killer == "player8":
		kills_list[7] = kills_list[7] + 1
		
func create_fighter(fighter):
	fighters_list.append(fighter)
	
func debug_placar():
	print('--------------------------------')
	print('## PLACAR ##')
	print('player 1 - K: ', kills_list[0],' / D: ', deaths_list[0])
	print('player 2 - K: ', kills_list[1],' / D: ', deaths_list[1])
	print('player 3 - K: ', kills_list[2],' / D: ', deaths_list[2])
	print('player 4 - K: ', kills_list[3],' / D: ', deaths_list[3])
	print('player 5 - K: ', kills_list[4],' / D: ', deaths_list[4])
	print('player 6 - K: ', kills_list[5],' / D: ', deaths_list[5])
	print('player 7 - K: ', kills_list[6],' / D: ', deaths_list[6])
	print('player 8 - K: ', kills_list[7],' / D: ', deaths_list[7])

func _on_Timer_PowerUp_timeout():
	choose_powerup = powerups.keys()[randi() % powerups.size()]
	if choose_powerup == "escudo":
		pu_choosed = powerup_escudo.instance()
	# elif ....
	rng.randomize()
	pu_choosed.position = Vector2(
		rng.randf_range(0, screen_limit_x),
		rng.randf_range(64, screen_limit_y)
	)
	level.add_child(pu_choosed)

func pegaram_powerup(player):
	if is_instance_valid(pu_choosed):
		pu_choosed.queue_free()
		if choose_powerup == "escudo":
			var pu_on_player = powerup_escudo.instance()
			pu_on_player.on_player = true
			pu_on_player.player_protegido = player
			player.add_child(pu_on_player)
		
		reset_timer_powerup()
	
func acabou_o_level():
	var campeao_pontos = 0
	var campeao_player = ''
	var ui_end = ui_end_level.instance()
		
	var scoreboard = []
	for i in range(0,8):
		scoreboard.append(kills_list[i] - deaths_list[i])
	
	campeao_pontos = scoreboard.max()
	if scoreboard.count(campeao_pontos) != 1:
		ui_end.champion_text = 'Empate!'
	else:
		campeao_player = scoreboard.find(campeao_pontos)
		if campeao_player == 0:
			campeao_player = 'player1'
		elif campeao_player == 1:
			campeao_player = 'player2'
		elif campeao_player == 2:
			campeao_player = 'player3'
		elif campeao_player == 3:
			campeao_player = 'player4'
		elif campeao_player == 4:
			campeao_player = 'player5'
		elif campeao_player == 5:
			campeao_player = 'player6'
		elif campeao_player == 6:
			campeao_player = 'player7'
		elif campeao_player == 7:
			campeao_player = 'player8'
		
		ui_end.champion_text = 'Campeão ' + campeao_player + ' com ' + str(campeao_pontos) + ' pontos!'
	level.add_child(ui_end)

func restart_game():
	#print('restart game')
	get_tree().change_scene("res://sandbox.tscn")
