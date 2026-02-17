shader_type canvas_item;

uniform float whiten : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Keep original alpha
	vec3 rgb = tex.rgb;

	// Mix toward white
	rgb = mix(rgb, vec3(1.0), whiten);

	COLOR = vec4(rgb, tex.a);
}
