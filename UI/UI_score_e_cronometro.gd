extends Control


onready var timer = $Timer
onready var cronometro_label = $Cronometro/Label
onready var score_p1 = $HSplitContainer/HSplitContainer/pontos_p1
onready var score_p2 = $HSplitContainer2/HSplitContainer/pontos_p2
onready var score_p3 = $HSplitContainer3/HSplitContainer/pontos_p3
onready var score_p4 = $HSplitContainer4/HSplitContainer/pontos_p4
onready var score_p5 = $HSplitContainer5/HSplitContainer/pontos_p5
onready var score_p6 = $HSplitContainer6/HSplitContainer/pontos_p6
onready var score_p7 = $HSplitContainer7/HSplitContainer/pontos_p7
onready var score_p8 = $HSplitContainer8/HSplitContainer/pontos_p8

onready var controller = get_node("/root/sandbox/Controller")



var tempo_level = 0
signal acabou_o_tempo()


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(tempo_level)
	timer.set_one_shot(true)
	timer.start()
	connect("acabou_o_tempo", controller, "acabou_o_level")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# otimizacao -> trocar o label somente quando o float estiver .00
	cronometro_label.set_text(str(round(timer.time_left)))


func set_tempo_level(tempo):
	tempo_level = tempo
	
func atualiza_placar(death_list, kills_list):
	# otimizacao -> atualizar somente o que mudou
	score_p1.set_text(str(kills_list[0]-death_list[0]))
	score_p2.set_text(str(kills_list[1]-death_list[1]))
	score_p3.set_text(str(kills_list[2]-death_list[2]))
	score_p4.set_text(str(kills_list[3]-death_list[3]))
	score_p5.set_text(str(kills_list[4]-death_list[4]))
	score_p6.set_text(str(kills_list[5]-death_list[5]))
	score_p7.set_text(str(kills_list[6]-death_list[6]))
	score_p8.set_text(str(kills_list[7]-death_list[7]))
	


func _on_Timer_timeout():
	# ACABOUU
	emit_signal("acabou_o_tempo")
