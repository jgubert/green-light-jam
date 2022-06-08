extends AudioStreamPlayer2D

var last_pitch = 1.0

func play(from_position=0.0):
	
	randomize()
	pitch_scale= rand_range(0.8, 1.2)
	
	while abs(pitch_scale - last_pitch) < 0.1:
		randomize()
		pitch_scale= rand_range(0.8, 1.2)
	
	.play(from_position)
