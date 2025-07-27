shader_type canvas_item;

uniform sampler2D image_texture;
uniform vec2 drill_pos;

void fragment()
{
	vec2 image_texture_size = vec2(textureSize(image_texture, 0));
	vec2 constrained_pos = mod(drill_pos + FRAGCOORD.xy, image_texture_size);
	vec2 uv = constrained_pos / image_texture_size;
	COLOR = texture(image_texture, uv);
}
