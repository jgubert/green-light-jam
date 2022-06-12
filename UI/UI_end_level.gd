extends Control


var champion_text = ''

onready var label = $CenterContainer/Panel/VSplitContainer/Label
onready var controller = get_node("/root/sandbox/Controller")

signal restart_game


# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(champion_text)
	connect('restart_game', controller, 'restart_game')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal('restart_game')
	queue_free()
