shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 0.0, 0.0, 0.5);

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
    COLOR = mix(tex, tint_color, 0.2);
}
