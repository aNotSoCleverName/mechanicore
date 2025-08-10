extends Panel
class_name Tutorial

const SPOTLIGHT_POS_KEY: String = "spotlightedRectPos";
const SPOTLIGHT_SIZE_KEY: String = "spotlightedRectSize";

@onready var _textNode: RichTextLabel = $Text;
@onready var _delayTimer: Timer = $"Delay Timer";

var _spotLightRect: Rect2;

func _ready():
	var shaderMaterial: ShaderMaterial = self.material;
	
	SignalBus_Tutorial.show_tutorial.connect(
		func (inPos: Vector2, inSize: Vector2, inText: String, inDelaySec):
			self._spotLightRect = Rect2(inPos, inSize);
			self._textNode.text = inText;
			
			self._delayTimer.wait_time = inDelaySec;
			self._delayTimer.start();
	)
	
	self._delayTimer.timeout.connect(
		func ():
			self._delayTimer.stop();
			
			self.visible = true;
			#self.get_tree().paused = true;
			
			shaderMaterial.set_shader_parameter(SPOTLIGHT_POS_KEY, self._spotLightRect.position);
			shaderMaterial.set_shader_parameter(SPOTLIGHT_SIZE_KEY, self._spotLightRect.size);
			
			self._DetermineBestPositionForText(self._spotLightRect);
	)
	
	SignalBus_Tutorial.hide_tutorial.connect(
		func ():
			self.visible = false;
			#self.get_tree().paused = false;
	)

#region Determine best position for text node
enum ETextPosRelativeToSpotlight { up, right, down, left }
func _DetermineBestPositionForText(inSpotlight: Rect2):
	# Key = enum, value = area
	var positionAndArea: Dictionary = { }
	
	# Check visible size in all positions
	for positionRelativeToSpotlight: ETextPosRelativeToSpotlight in ETextPosRelativeToSpotlight.values():
		self._SetTextPositionRelativeToSpotlight(positionRelativeToSpotlight, inSpotlight);
		positionAndArea[positionRelativeToSpotlight] = self._GetTextNodeVisibleArea();
	
	# Find best position (biggest visible size)
	var bestPos: ETextPosRelativeToSpotlight = ETextPosRelativeToSpotlight.up;
	var biggestArea: float = positionAndArea[bestPos];
	for positionRelativeToSpotlight: ETextPosRelativeToSpotlight in positionAndArea.keys():
		var area: float = positionAndArea[positionRelativeToSpotlight];
		if (area > biggestArea):
			bestPos = positionRelativeToSpotlight;
		else:
			biggestArea = area;
	
	self._SetTextPositionRelativeToSpotlight(bestPos, inSpotlight);

func _SetTextPositionRelativeToSpotlight(inPos: ETextPosRelativeToSpotlight, inSpotlight: Rect2) -> void:
	match inPos:
		ETextPosRelativeToSpotlight.up:
			self._textNode.position = Vector2(
				inSpotlight.position.x,
				inSpotlight.position.y - self._textNode.size.y
			);
		ETextPosRelativeToSpotlight.right:
			self._textNode.position = Vector2(
				inSpotlight.position.x + inSpotlight.size.x,
				inSpotlight.position.y
			);
		ETextPosRelativeToSpotlight.down:
			self._textNode.position = Vector2(
				inSpotlight.position.x,
				inSpotlight.position.y + inSpotlight.size.y
			);
		ETextPosRelativeToSpotlight.left:
			self._textNode.position = Vector2(
				inSpotlight.position.x - self._textNode.size.x,
				inSpotlight.position.y
			);
		_:
			assert(
				false,
				"Position unhandled",
			);

func _GetTextNodeVisibleArea() -> float:
	var visibleSize: Vector2 = self._textNode.get_rect().size;
	
	# If left or top is outside of screen
	if (self._textNode.position.x < 0):
		visibleSize.x += self._textNode.position.x;
	if (self._textNode.position.y < 0):
		visibleSize.y += self._textNode.position.y;
	
	# If right or bottom is outside of screen
	var textNodeBottomRight: Vector2 = Vector2(
		self._textNode.position.x + self._textNode.size.x,
		self._textNode.position.y + self._textNode.size.y,
	);
	var viewportSize: Vector2 = self._textNode.get_viewport_rect().size;
	if (textNodeBottomRight.x > viewportSize.x):
		visibleSize.x -= textNodeBottomRight.x - viewportSize.x;
	if (textNodeBottomRight.y > viewportSize.y):
		visibleSize.y -= textNodeBottomRight.y - viewportSize.y;
	
	return visibleSize.x * visibleSize.y;
#endregion
