shader_type canvas_item;

uniform float progress: hint_range(0, 1) = 0;

void fragment()
{
	if (UV.x > progress)
	{
		COLOR.rgb *= 0.5;
	}
	else
	{
		COLOR.rgb *= 1.2;
	}
}