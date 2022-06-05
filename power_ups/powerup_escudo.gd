extends Node2D

export var on_player = false
export var tempo_de_vida = 10
onready var powerup_area = $powerup_area
onready var timer = $Timer
onready var controller = get_node("/root/sandbox/Controller")

onready var player = ""

signal me_pegaram

# Called when the node enters the scene tree for the first time.
func _ready():
	if on_player:
		timer.set_wait_time(tempo_de_vida)
		timer.set_one_shot(true)
		timer.start()

func _on_powerup_area_area_entered(area):
	#print(area.name)
	player = area.get_parent()
	#print(player)
	connect("me_pegaram", controller, "pegaram_powerup", [player])
	emit_signal("me_pegaram")


func _on_Timer_timeout():
	queue_free()
