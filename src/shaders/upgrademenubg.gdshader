shader_type canvas_item;

uniform float selected : hint_range(0, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

float lerp(float delta, float a, float b) {
	return b*delta+a*(1.-delta);
}

void fragment() {
	float add = 0.0;
	if(selected > 0.0) {
		add = lerp(selected, 0., -0.05+sin(UV.y*TAU+TIME)*0.05);
	}
	COLOR *= COLOR+add;
	COLOR *= 0.8+selected*0.2;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
