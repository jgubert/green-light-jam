extends KinematicBody2D

# variaveis para movimentacao
# verificar quais nao estao sendo usadas
export var MAX_DASH_FORCE = 1500
export var ACCELERATION = 500
export var FRICTION = 500
export var DASH_FORCE = 0
export var DIRECTION = 1

# definicoes de tamanho de tela
var screen_limit_x = 640
var screen_limit_y = 360

var player = ""
var velocity = Vector2()
var shake_amount = 3
var shake_speed = 0.2
var current_pos = Vector2()
var final_pos = Vector2()

var rng = RandomNumberGenerator.new()

# variavel para guardar o inimigo para a batalha. talvez nao seja usada
var enemy

# variaveis com os nodes do rocket
onready var target = $pointing
onready var sprite = $Sprite
onready var collision_shape = $CollisionShape2D
onready var hurtbox = $hurtboxArea/hurtbox
onready var hitbox = $hitboxArea/hitbox
onready var animation_player = $AnimationPlayer
onready var death_timer = $DeathTimer
onready var charging_sprite = $charging
onready var charging_animation = $charging/charging_player

# sprites do player
const sprite_player1 = preload("res://Assets/Players/Player1.png")
const sprite_player2 = preload("res://Assets/Players/Player2.png")

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
			charging_animation.play("charging")
		else:
			if charging_sprite.visible == true:
				charging_sprite.visible = false
				charging_animation.play("stop")
			#toca animacao de dash carregado no max
			shake()
	
	if Input.is_action_just_released(player):
		state = DASH
		
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
	

func _on_Tween_tween_completed(object, key):	
	pass
	#shake()

func _on_hurtboxArea_area_entered(area):
	#print('HURTBOX ', player, ' ENTERED: ', area.name)	# DEBUG
	if area.name == 'hitboxArea':
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
	if area.name == 'hitboxArea':
		enemy = area.get_parent()
		if enemy != null:
			emit_signal("entering_battle")
			state = BATTLE
			print(player, ' entrou em batalha.')
	if area.name == 'hurtboxArea':
		emit_signal("player_matou")
		
func result_battle(result):
	if result == "lose":
		explode()
	if result == "win":
		emit_signal("player_matou")
		state = IDLE

func _on_DeathTimer_timeout():
	$"Boom-Sheet".visible = false #desativa sprite explosão
	emit_signal("player_morreu")
	queue_free() #remove node
