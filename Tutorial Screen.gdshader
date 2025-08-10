shader_type canvas_item;

uniform vec2 spotlightedRectPos;
uniform vec2 spotlightedRectSize;

void fragment()
{
	vec2 uv = UV / SCREEN_PIXEL_SIZE;
	if (
		((uv.x > spotlightedRectPos.x) && (uv.x < spotlightedRectPos.x + spotlightedRectSize.x)) &&
		((uv.y > spotlightedRectPos.y) && (uv.y < spotlightedRectPos.y + spotlightedRectSize.y))
	)
	{
		discard;
	}
}
