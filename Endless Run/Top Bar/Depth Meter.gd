extends Label

const SURFACE_Y_COORD: int = 256;

var _depth: float = 0:
	get:
		return _depth;
	set(inValue):
		_depth = inValue / 100;
		self.text = "Depth: " + str(_depth).pad_decimals(2) + "m"

func _ready() -> void:
	self._depth = 0;
	
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (inPos: Vector2):
			self._depth = inPos.y - self.SURFACE_Y_COORD;
	)
