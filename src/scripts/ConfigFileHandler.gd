extends Node

var config = ConfigFile.new();
const PATH = "user://settings.ini"

func _ready():
	if(!FileAccess.file_exists(PATH)):
		InputMap.load_from_project_settings();
		for action in InputMap.get_actions():
			if(action.contains("ui")):
				continue;
		
			var one = action;
			var two;
			var ev = InputMap.action_get_events(action);
			if ev.size() > 0:
				if ev[0] is InputEventKey:
					two = OS.get_keycode_string(ev[0].physical_keycode)
				elif ev[0] is InputEventMouseButton:
					two = str(ev[0].button_index) + "_MB"
			else:
				two = "???"
			config.set_value("keybind", one, two)
		
		config.save(PATH);
	else:
		config.load(PATH)
		
func saveBind(action: StringName, event: InputEvent):
	var event_str;
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = str(event.button_index) + "_MB"
	config.set_value("keybind", action, event_str);
	config.save(PATH);

func loadBinds():
	var binds = {};
	var keys = config.get_section_keys("keybind");
	for k in keys:
		var inp;
		var es = config.get_value("keybind", k);
		
		if(es.contains("_MB")):
			inp = InputEventMouseButton.new();
			inp.button_index = int(es.split("_")[0])
		else:
			inp = InputEventKey.new();
			inp.keycode = OS.find_keycode_from_string(es);
		binds[k] = inp
	return binds;
