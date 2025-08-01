extends Timer

var _drill: CharacterBody2D;

func _ready() -> void:
	self._drill = self.get_parent();
	
	self.timeout.connect(
		func ():
			SignalBus_EndlessRun.drill_change_pos.emit(self._drill.global_position);
	)
	
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, _inDrill: Drill):
			if (inIsDocked):
				self.stop();
			else:
				self.start();
	)
