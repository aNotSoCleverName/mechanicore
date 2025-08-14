extends Panel
class_name Tutorial

const SPOTLIGHT_POS_KEY: String = "spotlightedRectPos";
const SPOTLIGHT_SIZE_KEY: String = "spotlightedRectSize";

@onready var _textNode: TutorialText = $Text;

var _spotLightRect: Rect2;

func _ready():
	var shaderMaterial: ShaderMaterial = self.material;
	
	SignalBus_Tutorial.show_tutorial.connect(
		func (inNode: Node, inText: String):
			assert(
				(inNode is Node2D) || (inNode is Control),
				"inNode must be Node2D or Control so it has position and size"
			);
			
			#region Determine inNode's rect
			var rect: Rect2;
			if (inNode is Control):
				rect.position = UtilityNode.GetNodeWindowPos(inNode);;
				rect.size = (inNode.get_rect() as Rect2).size;
			elif (inNode is Node2D):
				var spriteNode;
				if (inNode is Sprite2D || inNode is AnimatedSprite2D):
					spriteNode = inNode;
				else:
					for childNode: Node in inNode.get_children():
						if (childNode is Sprite2D || childNode is AnimatedSprite2D):
							spriteNode = childNode;
							break;
				assert(
					spriteNode != null,
					"No sprite node found"
				)
				
				if (spriteNode is Sprite2D):
					rect.size = (spriteNode.get_rect() as Rect2).size * spriteNode.scale * inNode.scale;
				elif (spriteNode is AnimatedSprite2D):
					var spriteTexture: Texture2D = (spriteNode as AnimatedSprite2D).sprite_frames.get_frame_texture(spriteNode.animation, spriteNode.frame);
					rect.size = spriteTexture.get_size() * spriteNode.scale * inNode.scale;
				
				rect.position = UtilityNode.GetNodeWindowPos(spriteNode);
				if (spriteNode.centered):
					rect.position -= 0.5 * rect.size
			#endregion
			
			self._spotLightRect = rect;
			self._textNode.text = inText;
			self._textNode.OnTextChanged();
			
			self.visible = true;
			self.get_tree().paused = true;
			
			shaderMaterial.set_shader_parameter(SPOTLIGHT_POS_KEY, self._spotLightRect.position);
			shaderMaterial.set_shader_parameter(SPOTLIGHT_SIZE_KEY, self._spotLightRect.size);
			
			self._DetermineBestPositionForText(self._spotLightRect);
	)
	
	SignalBus_Tutorial.hide_tutorial.connect(
		func ():
			self.visible = false;
			self.get_tree().paused = false;
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

const TEXT_OFFSET_FROM_SPOTLIGHT: int = 15;
func _SetTextPositionRelativeToSpotlight(inPos: ETextPosRelativeToSpotlight, inSpotlight: Rect2) -> void:
	match inPos:
		ETextPosRelativeToSpotlight.up:
			self._textNode.position = Vector2(
				inSpotlight.position.x,
				inSpotlight.position.y - self._textNode.size.y - Tutorial.TEXT_OFFSET_FROM_SPOTLIGHT
			);
		ETextPosRelativeToSpotlight.right:
			self._textNode.position = Vector2(
				inSpotlight.position.x + inSpotlight.size.x + Tutorial.TEXT_OFFSET_FROM_SPOTLIGHT,
				inSpotlight.position.y
			);
		ETextPosRelativeToSpotlight.down:
			self._textNode.position = Vector2(
				inSpotlight.position.x,
				inSpotlight.position.y + inSpotlight.size.y + Tutorial.TEXT_OFFSET_FROM_SPOTLIGHT
			);
		ETextPosRelativeToSpotlight.left:
			self._textNode.position = Vector2(
				inSpotlight.position.x - self._textNode.size.x - Tutorial.TEXT_OFFSET_FROM_SPOTLIGHT,
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

func _input(event: InputEvent):
	if (!self.visible):
		return;
	
	if (
		event is InputEventMouseButton &&
		event.pressed &&
		event.button_index == MOUSE_BUTTON_LEFT
	):
		await get_tree().process_frame;
		SignalBus_Tutorial.hide_tutorial.emit();
	elif (
		event is InputEventKey &&
		event.is_pressed() &&
		event.is_action_pressed("ui_accept")
	):
		await get_tree().process_frame;
		SignalBus_Tutorial.hide_tutorial.emit();
