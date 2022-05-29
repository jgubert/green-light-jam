extends KinematicBody2D

export var MAX_DASH_FORCE = 1500
export var ACCELERATION = 500
export var FRICTION = 500
export var DASH_FORCE = 0
export var DIRECTION = 1

var player = "player1"
var velocity = Vector2()

var shake_amount = 3
var shake_speed = 0.2

var current_pos = Vector2()
var final_pos = Vector2()

var rng = RandomNumberGenerator.new()

onready var target = $pointing

enum {
	IDLE,
	DASH
}

var state = IDLE

		
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	randomize()
	position = Vector2(
		rng.randf_range(0, 800),
		rng.randf_range(0, 600))


func _physics_process(delta):
	match state:
		IDLE:
			idle_state(delta)
		DASH:
			dash_state(delta)

func idle_state(delta):
	self.rotation_degrees += DIRECTION * 2
	velocity = velocity * 0.85
	#print(velocity)
	#print('DASH FORCE: ', DASH_FORCE)
	
	
	if Input.is_action_pressed(player):
		#shake()	# shake tá deixando o dash estranho
		if DASH_FORCE < MAX_DASH_FORCE:
			DASH_FORCE = DASH_FORCE + 50
	
	if Input.is_action_just_released(player):
		state = DASH
		
	#debug
	#velocity = position.direction_to(target.get_global_position()) * DASH_FORCE
	move()
	
	# CORRIGIR QUANDO O PLAYER SAI DA TELA
	position.x = wrapf(position.x, 0, 800)
	position.y = wrapf(position.y, 0, 600)
	
func dash_state(delta):
	#print('DASH STATE')
	
	velocity = position.direction_to(target.get_global_position()) * DASH_FORCE
	#velocity = Vector2(DASH_FORCE, 0).rotated(rotation-90)
	DASH_FORCE = 0
	state = IDLE
	DIRECTION = -DIRECTION

func move():
	velocity = move_and_slide(velocity)

	
func shake():
	current_pos = self.position
	
	final_pos = Vector2(
		current_pos.x + (rng.randf_range(-1.0, 1.0) * shake_amount),
		current_pos.y + (rng.randf_range(-1.0, 1.0) * shake_amount))
	print(final_pos)
	$Sprite/Tween.interpolate_property(
		self,
		"position",
		current_pos,
		final_pos,
		shake_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	$Sprite/Tween.start()
	

func _on_Tween_tween_completed(object, key):	
	pass
	#shake()


func _on_hurtboxArea_area_entered(area):
	#print(area.name)
	if area.name == 'hitboxArea':
		queue_free()


func _on_hitboxArea_area_entered(area):
	#print(area.name)
	if area.name == 'hitboxArea':
		print('BATALHA DE BOTOES')
