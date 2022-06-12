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
var last_position = Vector2()	
#var final_pos = Vector2()	# variavel nao esta sendo usada
var protegido = false
var is_dashing = false

var rng = RandomNumberGenerator.new()

# variavel para guardar o inimigo para a batalha.
var enemy

# variaveis com os nodes do rocket
onready var target = $pointing
onready var rocket_back =$back
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
	
func battle_state(delta):
	pass
	
func dash_state(delta):
	if is_dashing == false:
		is_dashing = true
		velocity = position.direction_to(target.get_global_position()) * DASH_FORCE
		#velocity = Vector2(DASH_FORCE, 0).rotated(rotation-90)
		#var deg = rad2deg(velocity.angle())
		#var rad = velocity.angle()
		#print('deg> ', deg)
		#print('\tcos> ', cos(rad))
		#print('\tsin> ', sin(rad))
		DASH_FORCE = 0
		
		DIRECTION = -DIRECTION
		charging_sprite.visible = false
		charging_animation.play("stop")
		sprite.offset = Vector2(0,0)	# reseta offset do sprite
	elif is_dashing == true:
		#print(velocity.round().abs())
		if velocity.round().abs() < Vector2(40, 40):
			#print('parou')
			state = IDLE
			is_dashing = false
		else:
			#print("last_position: ", last_position)
			#print("self.position : ", self.position)
			last_position = self.position
			velocity = velocity * 0.85
			move()
			#print('ainda nao parou')
	

func move():
	velocity = move_and_slide(velocity)
	# CORRIGIR QUANDO O PLAYER SAI DA TELA
	position.x = wrapf(position.x, 0, screen_limit_x)
	position.y = wrapf(position.y, 64, screen_limit_y)

func shake():
	var shake_offset = Vector2(
		rng.randf_range(-1, 1), 
		rng.randf_range(-1, 1)
	)
	sprite.offset = shake_offset
	charging_sprite.offset = shake_offset
	


#func _on_hurtboxArea_area_entered(area):
#	#print('HURTBOX ', player, ' ENTERED: ', area.name)	# DEBUG
#	if area.name == 'hitboxArea' and !protegido:
#		explode()


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
	enemy = area.get_parent()
	#print('Colisao: ', player, ' com ', enemy.player, '\tArea: ', area)
	#print('\tplayer: protegido > ', protegido, '\tis_dashing > ', is_dashing)
	#print('\tenemy: protegido > ', enemy.protegido, '\tis_dashing > ', enemy.is_dashing)
	#var teste = rad2deg(Vector2(velocity.x + enemy.velocity.x , velocity.y + enemy.velocity.y ).angle())
	var seno = sin(velocity.angle()) + sin(enemy.velocity.angle())
	var coss = cos(velocity.angle()) + cos(enemy.velocity.angle())
	#print('self angle: ', velocity.angle(),'\tenemy angle: ', enemy.velocity.angle())
	#print('seno: ', seno, '\tself seno: ', sin(velocity.angle()), '\tenemy_seno: ', sin(enemy.velocity.angle()))
	#print('cosseno: ', coss, '\tself coss: ', cos(velocity.angle()), '\tenemy_coss: ', cos(enemy.velocity.angle()))
	if !protegido and !enemy.protegido and enemy.is_dashing and is_dashing and (abs(coss) < 0.2 or abs(seno) < 0.2):
		#print('COLISAO DE BATALHA')
		#print('distancia: ', Vector2(target.get_global_position()).distance_to(Vector2(enemy.target.get_global_position())))
		enemy = area.get_parent()
		if enemy != null:
			emit_signal("entering_battle")
			state = BATTLE
			#print(player, ' entrou em batalha.')
	elif protegido or (!enemy.is_dashing and is_dashing and !enemy.protegido):
		#print('CRASH: DE FRENTE COM INIMIGO PARADO / OU ESTOU PROTEGIDO')
		emit_signal("player_matou")
		enemy.explode()
		
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
