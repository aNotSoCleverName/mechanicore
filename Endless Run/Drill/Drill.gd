extends CharacterBody2D
class_name Drill

const PX_PER_METER: float = 100;

const START_SPEED: float = 500;
const MAX_MIN_SPEED: float = 1200;	# Maximum value of min speed. As drill gets deeper, min speed increases, but it will never be higher than this value.

@onready var upgradeComponentContainer: UpgradeComponentContainer = $"Upgrade Component Container";

#region Properties
var shield: int = 0:
	get:
		return shield;
	set(inValue):
		shield = inValue;
		SignalBus_EndlessRun.update_drill_shield.emit(self);

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
		
		SignalBus_EndlessRun.drill_change_dock.emit(_isDocked, self);
		if (_isDocked):
			self.shield = self.upgradeComponentContainer._stats[UpgradeComponentContainer.EStatsKeys.maxShield];
			self._speed = 0;
			self._directionDeg = SignalBus_EndlessRun.EDrillDirection.DOCKED;
			$AnimatedSprite2D.stop();
		else:
			self._directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
			$AnimatedSprite2D.play("drill_animation");

var _minSpeed: float = Drill.START_SPEED:
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
			var newSpeed: float = max(inValue, self._minSpeed);
			newSpeed = min(newSpeed, self._maxSpeed);
			if (_speed == newSpeed):
				return;
			_speed = newSpeed;
		
		self._UpdateVelocity();
		SignalBus_EndlessRun.drill_change_speed.emit(self);
		
		if (_speed == 0):
			self._isDocked = true;
		else:
			$AnimatedSprite2D.speed_scale = 1 + (_speed/self.START_SPEED);

var _maxSpeed: float = Drill.START_SPEED;

var _directionDeg: SignalBus_EndlessRun.EDrillDirection = SignalBus_EndlessRun.EDrillDirection.DOCKED:
	get:
		return _directionDeg;
	set(inValue):
		if (_directionDeg == inValue):
			return;
		
		if ($"Lock Dir Change Timer"._isLockDirChange && !self._isDocked):
			return;
		$"Lock Dir Change Timer".StartTimer();
		
		_directionDeg = inValue;
		self.rotation = deg_to_rad(inValue);
		self._UpdateVelocity();
		
		SignalBus_EndlessRun.drill_change_dir.emit(inValue);

var depth: float = 0.0:
	get:
		return depth;
	set(inValue):
		depth = inValue;
		self._minSpeed = min(self.MAX_MIN_SPEED, self.START_SPEED + self.depth);
		self._maxSpeed = self._minSpeed + self.upgradeComponentContainer._stats[UpgradeComponentContainer.EStatsKeys.maxSpeed];

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
			self.depth = (inPos.y - GlobalProperty_EndlessRun.SURFACE_Y) / Drill.PX_PER_METER;
	)
	
	SignalBus_EndlessRun.ore_pick.connect(
		func (inOre: Ore):
			var doubleOreChance: float = self.upgradeComponentContainer._stats[UpgradeComponentContainer.EStatsKeys.doubleOreChance];
			if (randf() < doubleOreChance):
				self.inventory[inOre.oreType] += 2;
			else:
				self.inventory[inOre.oreType] += 1;
	)
	
	SignalBus_EndlessRun.bomb_explode.connect(
		func ():
			self.shield -= 1;
	)

func _physics_process(_delta) -> void:
	move_and_slide();

func _input(event: InputEvent) -> void:
	if (!(event is InputEventKey)):
		return;
	var keycode: Key = (event as InputEventKey).keycode;
		
	if (event.is_action_pressed("ui_accept")):
		if (self._isDocked):
			self._isDocked = false;
			self._speed = self.START_SPEED;
		return;
	elif (event.is_action_pressed("ui_left")):
		if (!self._isDocked):
			self._directionDeg = SignalBus_EndlessRun.EDrillDirection.LEFT;
		return;
	elif (event.is_action_pressed("ui_right")):
		if (!self._isDocked):
			self._directionDeg = SignalBus_EndlessRun.EDrillDirection.RIGHT;
		return;
	
	if (keycode == KEY_R):
		if (!self._isDocked):
			self._isDocked = true;
		return;
#endregion
