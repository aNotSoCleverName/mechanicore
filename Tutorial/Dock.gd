extends Label

var _isEnabled: bool = false;

@onready var _visibleNotifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D;

func _ready():
	self._visibleNotifier.rect = self.get_rect();
	self._visibleNotifier.screen_entered.connect(
		func ():
			self._isEnabled = true;
	)

func _input(event: InputEvent):
	if (!self._isEnabled):
		return;
	
	if !(event is InputEventKey):
		return;
	var key: Key = (event as InputEventKey).keycode;
	
	if (key != Drill.DOCK_KEY):
		return;
	
	self.queue_free();
