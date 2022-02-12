shader_type canvas_item;

uniform vec4 block_color : hint_color;

void fragment() {
	COLOR = block_color;
}