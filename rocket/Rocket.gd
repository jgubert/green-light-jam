extends KinematicBody2D

# variaveis para movimentacao
export var MAX_DASH_FORCE = 1500
#export var ACCELERATION = 500	# variavel nao esta sendo usada
#export var FRICTION = 500	# variavel nao esta sendo usada
export var DASH_FORCE = 0
export var DIRECTION = 1

# definicoes de tamanho de tela
var screen_limit_x = 640
var screen_limit_y = 360

var player = ""
var velocity = Vector2()
#var shake_amount = 3	# variavel nao esta sendo usada
#var shake_speed = 0.2	# variavel nao esta sendo usada
#var current_pos = Vector2()	# variavel nao esta sendo usada
#var final_pos = Vector2()	# variavel nao esta sendo usada
var protegido = false

var rng = RandomNumberGenerator.new()

# variavel para guardar o inimigo para a batalha.
var enemy

# variaveis com os nodes do rocket
onready var target = $pointing
onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D
onready var hurtbox = $hurtboxArea/hurtbox
onready var hitbox = $hitboxArea/hitbox
onready var animation_player = $AnimationPlayer
onready var death_timer = $DeathTimer
onready var charging_sprite = $"Charge-Sheet"
onready var charging_animation = $charging/charging_player

# sprites do player
const sprite_player1 = preload("res://Assets/Players/Player1.png")
const sprite_player2 = preload("res://Assets/Players/Player2.png")
const sprite_player3 = preload("res://Assets/Players/Player3.png")
const sprite_player4 = preload("res://Assets/Players/Player4.png")
const sprite_player5 = preload("res://Assets/Players/Player5.png")
const sprite_player6 = preload("res://Assets/Players/Player6.png")
const sprite_player7 = preload("res://Assets/Players/Player7.png")
const sprite_player8 = preload("res://Assets/Players/Player8.png")

# node controller
onready var controller = get_node("/root/sandbox/Controller")

# sinais
signal player_morreu(player)
signal player_matou(player)

signal entering_battle(himself)

enum {
	IDLE,
	DASH,
	BATTLE
}

var state = IDLE
var animation

# Funcao _ready é chamada quando o node rocket é colocado na tela
func _ready():
	# Cria o rocket em uma posicao aleatoria na tela
	rng.randomize()
	randomize()
	position = Vector2(
		rng.randf_range(0, screen_limit_x),
		rng.randf_range(0, screen_limit_y))
	
	# carrega o sprite do player correto
	if player == "player1":
		sprite.set_texture(sprite_player1)
	elif player == "player2":
		sprite.set_texture(sprite_player2)
	elif player == "player3":
		sprite.set_texture(sprite_player3)
	elif player == "player4":
		sprite.set_texture(sprite_player4)
	elif player == "player5":
		sprite.set_texture(sprite_player5)
	elif player == "player6":
		sprite.set_texture(sprite_player6)
	elif player == "player7":
		sprite.set_texture(sprite_player7)
	elif player == "player8":
		sprite.set_texture(sprite_player8)
	
	# conecta o sinal com o controller
	connect("player_morreu", controller, "get_rocket_deaths", [player])
	connect("player_matou", controller, "get_rocket_kill", [player])
	connect("entering_battle", controller, "create_fighter", [self])

func _physics_process(delta):
	match state:
		IDLE:
			idle_state(delta)
		DASH:
			dash_state(delta)
		BATTLE:
			battle_state(delta)

func idle_state(delta):
	self.rotation_degrees += DIRECTION * 2
	velocity = velocity * 0.85
	#print(velocity)
	#print('DASH FORCE: ', DASH_FORCE)
	
	
	if Input.is_action_pressed(player):
		if DASH_FORCE < MAX_DASH_FORCE:
			DASH_FORCE = DASH_FORCE + 50
			# toca a animacao de charging
			charging_sprite.visible = true
			animation_player.play("Charging")
		else:
			if charging_sprite.visible == true:
				animation_player.play("Charged")
			#toca animacao de dash carregado no max
			shake()
	
	if Input.is_action_just_released(player):
		state = DASH
		animation_player.play("Dash")
		
	#debug
	#velocity = position.direction_to(target.get_global_position()) * DASH_FORCE
	move()
	
	# CORRIGIR QUANDO O PLAYER SAI DA TELA
	position.x = wrapf(position.x, 0, screen_limit_x)
	position.y = wrapf(position.y, 0, screen_limit_y)
	
func battle_state(delta):
	pass
	
func dash_state(delta):
	#print('DASH STATE')
	velocity = position.direction_to(target.get_global_position()) * DASH_FORCE
	#velocity = Vector2(DASH_FORCE, 0).rotated(rotation-90)
	DASH_FORCE = 0
	state = IDLE
	DIRECTION = -DIRECTION
	
	charging_sprite.visible = false
	charging_animation.play("stop")
	
	sprite.offset = Vector2(0,0)	# reseta offset do sprite

func move():
	velocity = move_and_slide(velocity)

func shake():
	sprite.offset = Vector2(
		rng.randf_range(-1, 1), 
		rng.randf_range(-1, 1)
	)
	

func _on_hurtboxArea_area_entered(area):
	#print('HURTBOX ', player, ' ENTERED: ', area.name)	# DEBUG
	if area.name == 'hitboxArea' and !protegido:
		explode()

func explode():
	sprite.visible = false # desativa sprite nave
	# a hitbox ainda estava matando o player na explosao
	collision_shape.queue_free()
	$CollisionShape2D2.queue_free()
	$hitboxArea.queue_free()	# destroi a area de hitbox
	$hurtboxArea.queue_free()	# destroi a area de hurtbox
	set_physics_process(false) #desativa rotação idle_state
	self.rotation_degrees = 0 #reseta rotação
	$"Boom-Sheet".visible = true #ativa sprite explosão
	animation_player.play("Death")
	death_timer.start()
	
func _on_hitboxArea_area_entered(area):
	#print(area.name, protegido)
	enemy = area.get_parent()
	if area.name == 'hitboxArea' and !protegido and !enemy.protegido:
		enemy = area.get_parent()
		if enemy != null:
			emit_signal("entering_battle")
			state = BATTLE
			print(player, ' entrou em batalha.')
	elif area.name == 'hitboxArea' and protegido:
		emit_signal("player_matou")
	if area.name == 'hurtboxArea':
		emit_signal("player_matou")
		
func result_battle(result):
	if result == "lose":
		explode()
	if result == "win":
		emit_signal("player_matou")
		state = IDLE

# pra quando buga a batalha, sai do estado de batalha e volta pro idle
func back_to_idle():
	state = IDLE

func _on_DeathTimer_timeout():
	$"Boom-Sheet".visible = false #desativa sprite explosão
	emit_signal("player_morreu")
	queue_free() #remove node
