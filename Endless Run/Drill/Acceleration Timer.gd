extends Timer

@onready var _drill: Drill = self.get_parent();
var _acceleration: float = 30;

func _ready():
	self.timeout.connect(
		func ():
			self._drill._speed = max(self._drill._speed + self._acceleration, self._drill._minSpeed);
	)

func _input(event):
	if (self._drill._isDocked):
		return;
	
	if (!(event is InputEventKey)):
		return;
	
	if (event.is_pressed()):
		self.start();
	elif (event.is_released()):
		self.stop();
	
	if (event.is_action("ui_up")):
		self._acceleration = -1 * absf(self._acceleration);
	elif (event.is_action("ui_down")):
		self._acceleration = absf(self._acceleration);
