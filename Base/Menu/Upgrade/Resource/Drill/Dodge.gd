extends Node2D
class_name DodgeComponent

var _drill: Drill;

const DOUBLE_TAP_WINDOW: float = 0.3;
@onready var _doubleTapTimer: Timer = $"Double Tap Window Timer";

const DODGE_TIME: float = 0.1;
@onready var _dodgeTimer: Timer = $"Dodge Timer";
const DODGE_SPEED: float = 1500;

const DODGE_COOLDOWN_SEC: float = 1;
@onready var _cooldownTimer: Timer = $"Cooldown Timer";

var _lastTappedKey: Key = KEY_ESCAPE;	# Esc = null

func _ready():
	self._drill = self.get_parent().get_parent();
	
	self._doubleTapTimer.wait_time = self.DOUBLE_TAP_WINDOW;
	self._doubleTapTimer.timeout.connect(
		func ():
			self._lastTappedKey = KEY_ESCAPE;
			self._doubleTapTimer.stop();
	)
	
	self._dodgeTimer.wait_time = self.DODGE_TIME;
	self._dodgeTimer.timeout.connect(
		func ():
			self._drill.isDodging = false;
			self._dodgeTimer.stop();
	)
	
	self._cooldownTimer.wait_time = self.DODGE_COOLDOWN_SEC;
	self._cooldownTimer.timeout.connect(
		func ():
			self._cooldownTimer.stop();
	)

func _input(event: InputEvent):	# Dodge on double tap
	if !(event is InputEventKey):
		return;
	
	if (self._drill._isDocked):
		return;
	
	if (self._cooldownTimer.time_left > 0):
		return;
	
	if (!event.is_action("ui_left") && !event.is_action("ui_right")):
		return;
	
	var key: Key = (event as InputEventKey).keycode;
	
	if (event.is_released()):
		self._lastTappedKey = key;
		self._doubleTapTimer.start();
		return;
	
	if (self._lastTappedKey != key):
		return;
	self._lastTappedKey = KEY_ESCAPE;
	
	self._dodgeTimer.start();
	self._cooldownTimer.start();
	
	self._drill.isDodging = true;
	
	if (event.is_action_pressed("ui_left")):
		self._drill.velocity.x -= self.DODGE_SPEED;
	else:
		self._drill.velocity.x += self.DODGE_SPEED;
