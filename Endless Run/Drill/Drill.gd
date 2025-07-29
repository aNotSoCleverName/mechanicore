extends CharacterBody2D
class_name Drill

const START_VELOCITY: int = 100;

#region Properties
var _isDocked: bool = true:
	get:
		return _isDocked;
	set(inValue):
		_isDocked = inValue;
		
		SignalBus_EndlessRun.drill_change_dock.emit(_isDocked);
		if (_isDocked):
			self._speed = 0;

var _speed: int = 0:
	get:
		return _speed;
	set(inValue):
		_speed = inValue;
		self._UpdateVelocity();
		
		if (_speed == 0):
			self._isDocked = true;

var _directionDeg: SignalBus_EndlessRun.EDrillDirection = SignalBus_EndlessRun.EDrillDirection.DOCKED:
	get:
		return _directionDeg;
	set(inValue):
		if (self._isDocked):
			return;
		if (_directionDeg == inValue):
			return;
		
		if ($"Lock Dir Change Timer"._isLockDirChange):
			return;
		$"Lock Dir Change Timer".StartTimer();
		
		_directionDeg = inValue;
		self.rotation = deg_to_rad(inValue);
		self._UpdateVelocity();
		
		SignalBus_EndlessRun.drill_change_dir.emit(inValue);

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
	
	SignalBus_EndlessRun.ore_pick.connect(
		func (inOre: Ore):
			self.inventory[inOre.oreType] += 1;
	)

func _physics_process(_delta) -> void:
	move_and_slide();

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return;
	var keycode: Key = (event as InputEventKey).keycode;
	
	if (event.pressed):
		if (keycode == KEY_SPACE):
			self._isDocked = false;
			self._speed = START_VELOCITY;
			_directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
		if (keycode == KEY_A || keycode == KEY_LEFT):
			_directionDeg = SignalBus_EndlessRun.EDrillDirection.LEFT;
		elif (keycode == KEY_D || keycode == KEY_RIGHT):
			_directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
#endregion
