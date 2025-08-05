shader_type canvas_item;

uniform int maxShield = 0;
uniform int shield = 0;

void fragment() {
	if (shield <= 0)
		discard;
	
	vec2 uv = UV * 2.0 - 1.0;
    float dist = length(uv);
    if (dist > 1.0)
        discard;
	
	float transparancyMult = pow(
		dist,
		2.0 * float(maxShield-shield) + 1.0
	);
    COLOR = vec4(
		46.0/255.0,
		255.0/255.0,
		150.0/255.0,
		COLOR.a * transparancyMult
	);
}
