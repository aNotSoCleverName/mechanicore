extends Label

@onready var _drill: Drill = GlobalProperty_EndlessRun.GetDrillNode(self);

func _input(event: InputEvent):
	if !(event is InputEventKey):
		return;
	
	if (self._drill._isDocked):
		return;
	
	if (!event.is_action_pressed("ui_left") && !event.is_action_released("ui_right")):
		return;
	
	self.queue_free();
