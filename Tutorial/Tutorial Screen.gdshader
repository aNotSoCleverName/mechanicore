shader_type canvas_item;

uniform vec2 tutorialScreenSize;
uniform vec2 spotlightedRectPos;
uniform vec2 spotlightedRectSize;

const vec2 margin = vec2(5.0, 5.0);
const vec2 borderWidth = vec2(3.0, 3.0);

bool IsPixelInRect(vec2 inPixelPos, vec2 inRectTopLeft, vec2 inRectSize)
{
	return (
		((inPixelPos.x > inRectTopLeft.x) && (inPixelPos.x < inRectTopLeft.x + inRectSize.x)) &&
		((inPixelPos.y > inRectTopLeft.y) && (inPixelPos.y < inRectTopLeft.y + inRectSize.y))
	);
}

void fragment()
{
	vec2 uv = UV * tutorialScreenSize;
	
	vec2 rectPosWithMargin = spotlightedRectPos - margin;
	vec2 rectSizeWithMargin = spotlightedRectSize + 2.0*margin;
	
	vec2 borderPos = rectPosWithMargin - borderWidth;
	vec2 borderSize = rectSizeWithMargin + 2.0*borderWidth;
	
	if (IsPixelInRect(uv, rectPosWithMargin, rectSizeWithMargin))
	{
		discard;
	}
	else if (IsPixelInRect(uv, borderPos, borderSize))
	{
		COLOR = vec4(0.0, 1.0, 0.0, 1.0);
	}
}