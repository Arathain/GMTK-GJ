shader_type canvas_item;

uniform sampler2D screenTexture : hint_screen_texture, filter_linear_mipmap;
uniform float blur : hint_range(0., 10.);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 col = textureLod(screenTexture, SCREEN_UV, blur);
	COLOR = col*col;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
