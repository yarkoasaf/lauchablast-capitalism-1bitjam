shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;

uniform vec4 color_a : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_b : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec3 col = texture(screen_tex, SCREEN_UV).rgb;

	float lum = dot(col, vec3(0.2126, 0.7152, 0.0722));
	float m = step(threshold, lum);

	COLOR = mix(color_a, color_b, m);
}
