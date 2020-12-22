shader_type canvas_item;

uniform bool test = false;

void fragment() {
	if(test) {
		COLOR = vec4(0, 0, 0, .5)
	}
	else {
		COLOR = vec4(0, UV/16.0, 1)
	}
}