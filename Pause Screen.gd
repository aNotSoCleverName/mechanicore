extends PanelContainer

var _isPaused: bool = false;

func _TogglePause():
	var main: Control = self.get_parent();
	
	self._isPaused = !self._isPaused;
	main.move_child(
		self,
		main.get_child_count() - 1 if self._isPaused else 0
	);
	
	self.get_tree().paused = self._isPaused;

func _input(event: InputEvent):
	if !(event is InputEventKey):
		return;
	
	if (event.is_pressed()):
		return;
	
	var key: Key = (event as InputEventKey).keycode;
	
	if (key != KEY_ESCAPE):
		return;
	
	self._TogglePause();

func _on_continue_button_pressed():
	self._TogglePause();
