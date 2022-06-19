extends Button

var key
var value
var menu
var original_key

export var waiting_input = false
onready var menu_controles = get_node("/root/MenuControles")

func _ready():
	self.toggle_mode = true
	#self.focus_mode = Control.FOCUS_NONE
	
func _toggled(button_pressed):
	self.grab_focus()
	self.waiting_input = true
	original_key = self.text
	self.set_text("")
	
func _input(event):
	if self.waiting_input:
		if event is InputEventKey:
			value = event.scancode
			self.text = OS.get_scancode_string(value)
			waiting_input = false
			menu_controles.keybinds[key] = value
			self.release_focus()
		if event is InputEventMouseButton:
			waiting_input = false
			self.set_text(original_key)
			self.release_focus()
