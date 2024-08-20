extends HSlider

@export
var bus_name : String;

var bi : int;

@onready
var rectl := $MarginContainer/HBoxContainer/NinePatchRect;
@onready
var rectr := $MarginContainer/HBoxContainer/NinePatchRect2;

func _ready():
	bi = AudioServer.get_bus_index(bus_name);
	value_changed.connect(onScroll)
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bi)
	)

var rectsize := 192.0;

func _process(delta):
	var sizetotal = rectsize*2.0+4.0;
	var perc = value/max_value;
	var valleft = perc*2.0-8.0/sizetotal;
	var valright = 2.0-perc*2.0+8.0/sizetotal;
	rectl.custom_minimum_size.x = int(rectsize*valleft);
	rectr.custom_minimum_size.x = int(rectsize*valright);

func onScroll(val : float):
	AudioServer.set_bus_volume_db(
		bi,
		linear_to_db(value)
	)
