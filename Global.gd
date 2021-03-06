extends Node

var filepath = "res://keybinds.ini"
var configfile

var keybinds = {}

func _ready():
	configfile = ConfigFile.new()
	if configfile.load(filepath) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			#print(key, " : ", OS.get_scancode_string(key_value))
			
			keybinds[key] = key_value
	else:
		generate_default_binds()
		write_config()
	
	set_game_binds()
	
func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
			
		var new_key = InputEventKey.new()
		new_key.set_scancode(value)
		InputMap.action_add_event(key, new_key)

func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		configfile.set_value("keybinds", key, key_value)
	configfile.save(filepath)

func generate_default_binds():
	keybinds["player1"] = 65
	keybinds["player2"] = 83
	keybinds["player3"] = 68
	keybinds["player4"] = 70
	keybinds["player5"] = 90
	keybinds["player6"] = 88
	keybinds["player7"] = 67
	keybinds["player8"] = 86
