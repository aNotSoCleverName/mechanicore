extends CharacterBody2D

const START_VELOCITY: int = 100;

#region Properties
var _isDocked: bool = true:
	get:
		return _isDocked;
	set(inValue):
		_isDocked = inValue;

var _speed: int = 0:
	get:
		return _speed;
	set(inValue):
		_speed = inValue;
		self._UpdateVelocity();

var _directionDeg: SignalBus_EndlessRun.EDrillDirection:
	get:
		return _directionDeg;
	set(inValue):
		if (self._isDocked):
			return;
		if (_directionDeg == inValue):
			return;
		_directionDeg = inValue;
		
		SignalBus_EndlessRun.drill_change_dir.emit(inValue);
		self._UpdateVelocity();
#endregion

#region Private functions
func _UpdateVelocity() -> void:
	var dirAngle: Vector2 = Vector2.DOWN.rotated(
		deg_to_rad(self._directionDeg)
	);
	velocity = self._speed * dirAngle;
#endregion

#region Built-in functions
func _physics_process(delta) -> void:
	move_and_slide();

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return;
	var keycode: Key = (event as InputEventKey).keycode;
	
	if event.is_action_pressed("ui_accept"):
		self._isDocked = false;
		self._speed = START_VELOCITY;
		_directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
	if event.is_action_pressed("ui_left"):
		_directionDeg = SignalBus_EndlessRun.EDrillDirection.LEFT;
	elif event.is_action_pressed("ui_right"):
		_directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
	
	"""
	if (event.pressed):
		if (keycode == KEY_SPACE):
			self._isDocked = false;
			self._speed = START_VELOCITY;
			_directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
		if (keycode == KEY_A || keycode == KEY_LEFT):
			_directionDeg = SignalBus_EndlessRun.EDrillDirection.LEFT;
		elif (keycode == KEY_D || keycode == KEY_RIGHT):
			_directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
	"""
#endregion
