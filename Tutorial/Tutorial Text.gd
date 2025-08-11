extends RichTextLabel
class_name TutorialText

const MAX_WIDTH: float = 400;

@onready var _background: ColorRect = $ColorRect;
const BACKGROUND_MARGIN: int = 3;

func OnTextChanged() -> void:
	self.size.x = self.get_parent().size.x;
	self.size.x = min(self.get_content_width(), TutorialText.MAX_WIDTH);
	await get_tree().process_frame;
	
	self.size.y = self.get_content_height();
	self._background.size = (
		self.size +
		2 * Vector2(TutorialText.BACKGROUND_MARGIN, TutorialText.BACKGROUND_MARGIN)
	);

func _ready():
	assert(
		TutorialText.MAX_WIDTH >= self.custom_minimum_size.x,
		"Tutorial Text's max width must be bigger than min width"
	);
	
	self._background.position = -Vector2(TutorialText.BACKGROUND_MARGIN, TutorialText.BACKGROUND_MARGIN)
