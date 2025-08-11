extends Label

func _input(event: InputEvent):
	if !(event is InputEventKey):
		return;
	
	if (!event.is_action_pressed("ui_accept")):
		return;
	
	self.queue_free();
