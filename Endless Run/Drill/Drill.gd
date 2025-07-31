extends CharacterBody2D
class_name Drill

const START_SPEED: float = 1000;
const MAX_MIN_SPEED: float = 1200;	# Maximum value of min speed. As drill gets deeper, min speed increases, but it will never be higher than this value.

#region Properties
var _isDocked: bool = true:
	get:
		return _isDocked;
	set(inValue):
		if (_isDocked == inValue):
			return;
		_isDocked = inValue;
		
		self.global_position = Vector2(
			GlobalProperty_EndlessRun.VIEWPORT_SIZE.x/2,
			GlobalProperty_EndlessRun.SURFACE_Y
		);
		
		SignalBus_EndlessRun.drill_change_dock.emit(_isDocked);
		if (_isDocked):
			self._speed = 0;
			self._directionDeg = SignalBus_EndlessRun.EDrillDirection.DOCKED;
			$AnimatedSprite2D.stop();
		else:
			self._directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
			$AnimatedSprite2D.play("drill_animation");

var _minSpeed: float = self.START_SPEED:
	get:
		return _minSpeed;
	set(inValue):
		if (_minSpeed == inValue):
			return;
		_minSpeed = inValue;
		
		self._speed = max(self._speed, _minSpeed);

var _speed: float = 0:
	get:
		return _speed;
	set(inValue):
		if (self._isDocked):
			_speed = 0;
		else:
			var newSpeed: float = max(inValue, _minSpeed);
			if (_speed == newSpeed):
				return;
			_speed = newSpeed;
		
		self._UpdateVelocity();
		
		if (_speed == 0):
			self._isDocked = true;
		else:
			$AnimatedSprite2D.speed_scale = 1 + (_speed/self.START_SPEED);

var _directionDeg: SignalBus_EndlessRun.EDrillDirection = SignalBus_EndlessRun.EDrillDirection.DOCKED:
	get:
		return _directionDeg;
	set(inValue):
		if (_directionDeg == inValue):
			return;
		
		if ($"Lock Dir Change Timer"._isLockDirChange):
			return;
		$"Lock Dir Change Timer".StartTimer();
		
		_directionDeg = inValue;
		self.rotation = deg_to_rad(inValue);
		self._UpdateVelocity();
		
		SignalBus_EndlessRun.drill_change_dir.emit(inValue);

var depth: float = 0.0:
	get:
		return depth;

### Stores ore
### Key = ore type, value = amount
var inventory: Dictionary = { }:
	get:
		return inventory;
#endregion

#region Private functions
func _UpdateVelocity() -> void:
	velocity = self._speed * Vector2.RIGHT.rotated(self.rotation);
#endregion

#region Built-in functions
func _on_tree_entered() -> void:
	# Initiate dictionary
	for type in Ore.EOreType.values():
		self.inventory[type] = 0;
	
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (inPos: Vector2):
			self.depth = (inPos.y - GlobalProperty_EndlessRun.SURFACE_Y) / 100;
			self._minSpeed = min(self.MAX_MIN_SPEED, self.START_SPEED + self.depth);
	)
	
	SignalBus_EndlessRun.ore_pick.connect(
		func (inOre: Ore):
			self.inventory[inOre.oreType] += 1;
	)

func _physics_process(_delta) -> void:
	move_and_slide();

func _input(event: InputEvent) -> void:
	if (!(event is InputEventKey)):
		return;
	var keycode: Key = (event as InputEventKey).keycode;
		
	if (event.is_action_pressed("ui_accept")):
		if (!self._isDocked):
			return;
		self._isDocked = false;
		self._speed = self.START_SPEED;
	elif (event.is_action_pressed("ui_left")):
		if (self._isDocked):
			return;
		self._directionDeg = SignalBus_EndlessRun.EDrillDirection.LEFT;
	elif (event.is_action_pressed("ui_right")):
		if (self._isDocked):
			return;
		self._directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
	
	elif (keycode == KEY_R):
		if (self._isDocked):
			return;
		self._isDocked = true;
#endregion
