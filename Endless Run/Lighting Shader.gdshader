shader_type canvas_item;

uniform vec2 viewportSize = vec2(896.0, 720.0);
uniform float surfaceY = 256.0;
uniform float scrollOffset = 0;
uniform vec2 drillPosRelativeToScrolledViewport = vec2(448.0, 256.0);

void fragment() {
	vec2 uvUnscrolled = UV * viewportSize;

	vec2 uvScrolled = vec2(uvUnscrolled.x, uvUnscrolled.y + scrollOffset);
	bool isAboveGround = uvScrolled.y <= surfaceY;
	
	if (isAboveGround)
	{
		discard;
	}
	
	float distFromDrill = length(uvUnscrolled - drillPosRelativeToScrolledViewport);
	float lightDist = 700.0;
	float opacity = clamp(
		distFromDrill/lightDist,
		0.0,
		1.0
	);
	
	//float distFromDrill = length(UV - drillPosRelativeToScrolledViewport/viewportSize);
	//float opacity = pow(
		//distFromDrill * 1.5,
		//3.0
	//);
	
	COLOR = vec4(
		0.0/255.0,
		0.0/255.0,
		0.0/255.0,
		opacity
	);
}
