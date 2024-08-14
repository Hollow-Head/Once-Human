shader_type canvas_item;

uniform bool active;

void fragment() {
	if(COLOR.a > 0.0 && active){
		COLOR = vec4(1.0, 1.0, 1.0, 1.0);
	}
}
