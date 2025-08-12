extends Label

func _input(event: InputEvent):
	if !(event is InputEventKey):
		return;
	
	if (!event.is_action_pressed("ui_accept")):
		return;
	
	SignalBus_Tutorial.hasStartedDigging = true;
	
	self.queue_free();
