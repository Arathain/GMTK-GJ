shader_type canvas_item;
render_mode skip_vertex_transform;

uniform vec2 offset;
uniform vec2 scale;
uniform int resolution;

varying vec2 coord;

void vertex() {
}

void fragment() {
	//vec2 uv = (UV+offset/80.0)*scale;
	vec2 offs = offset/(float(resolution)*0.5);
	vec2 uv = ((SCREEN_UV)-0.5)*(2.0/scale)+0.5+offs;
	uv *= 3.0;
	uv.y += sin(uv.x * TAU + TIME * 0.01)*0.1;
	COLOR = textureLod(TEXTURE, uv+TIME*(-0.01), 0.1);
	//COLOR = vec4(uv, 0.0, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
