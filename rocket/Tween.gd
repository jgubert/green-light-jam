extends Sprite

var shake_amount = 5.0
var shake_speed = 0.1

var current_pos = Vector2()
var final_pos = Vector2()

var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	
	shake()


func shake():
	current_pos = position
	final_pos = Vector2(
		rng.randf_range(-1.0, 1.0),
		rng.randf_range(-1.0, 1.0)) * shake_amount
	
	$Tween.interpolate_property(
		self,
		"position",
		current_pos,
		final_pos,
		shake_speed,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	$Tween.start()
	

func _on_Tween_tween_completed(object, key):	
	shake()
