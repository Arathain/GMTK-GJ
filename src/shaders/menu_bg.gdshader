shader_type canvas_item;

uniform sampler2D noise;
uniform vec3 color : source_color;
uniform vec3 bgcolor : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV-0.5;
	float l = abs(sin(atan(uv.x/uv.y)+(TIME*0.05*TAU)));
	l *= l;
	//l += abs(sin(atan(uv.x/uv.y)+TIME*0.31+0.2))*0.6;
	l *= length(uv)-cos((TIME*0.05*TAU))*0.2;
	vec2 uvMoved = vec2(mod(UV.x-TIME*0.002*TAU, 1.), UV.y);
	l *= min(textureLod(noise, uvMoved, 3.0).r+0.3, 1.0);
	l *= min(uv.y+0.1, 1.0);
	COLOR = vec4(color*l+bgcolor, 1.);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
