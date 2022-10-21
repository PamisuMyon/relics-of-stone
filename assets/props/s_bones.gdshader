shader_type spatial;
uniform vec4 base_color : source_color;
uniform vec4 edge_color : source_color;


void fragment() {
	float fresnel = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 1.5);
	vec4 emission = edge_color * fresnel;

	ALBEDO = vec3(base_color.xyz);
	EMISSION = vec3(emission.xyz);
}
