extends Camera2D

var _drill: Drill;
var _viewportRect: Rect2;

func _ready() -> void:
	self._drill = self.find_parent("Endless Run").find_child("Drill");
	self._viewportRect = get_viewport_rect();

func _process(_delta) -> void:
	self.global_position.x = self._viewportRect.size.x / 2;
	self.global_position.y = self._drill.global_position.y;
