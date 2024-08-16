extends Control

@onready var inputButton = preload("res://scenes/input_button.tscn");
@onready var bindList = $MarginContainer2/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/BindList;

var selectedBind = null;
var remapButton = null;

func _ready():
	loadBinds();
	createBindList();

func loadBinds():
	var binds = ConfigFileHandler.loadBinds();
	for act in binds.keys():
		InputMap.action_erase_events(act);
		InputMap.action_add_event(act, binds[act]);

func createBindList():
	
	for i in bindList.get_children():
		i.queue_free()
	
	for action in InputMap.get_actions():
		if(action.contains("ui")):
			continue;
		var inst = inputButton.instantiate();
		var labelA = inst.find_child("LabelAction");
		var labelI = inst.find_child("LabelInput");
		
		labelA.text = (action).replace("_", " ").to_upper();
		var ev = InputMap.action_get_events(action);
		if ev.size() > 0:
			labelI.text = ev[0].as_text().trim_suffix(" (Physical)");
		else:
			labelI.text = "???"
		bindList.add_child(inst);
		inst.pressed.connect(onInputPress.bind(inst, action));

func onInputPress(button, bind):
	if (selectedBind == null) :
		selectedBind = bind;
		remapButton = button;
		button.find_child("LabelInput").text = "Press key to rebind.";
		

func _input(event):
	if(selectedBind != null):
		var bl = event is InputEventMouseButton && event.pressed;
		if(bl && event.double_click):
			event.double_click = false;
		if (event is InputEventKey || (bl)):
			InputMap.action_erase_events(selectedBind);
			InputMap.action_add_event(selectedBind, event);
			ConfigFileHandler.saveBind(selectedBind, event);
			updateBinds(remapButton, event)
			selectedBind = null;
			remapButton = null;
			accept_event();

func updateBinds(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)");


func _on_back_pressed():
	GlobalStorage.loadSceneTransition("menu");
