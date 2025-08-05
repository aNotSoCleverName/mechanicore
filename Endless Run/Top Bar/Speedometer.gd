extends Label

func _ready():
	SignalBus_EndlessRun.drill_change_speed.connect(
		func (inDrill: Drill):
			self.text = str(
				 inDrill._speed / Drill.PX_PER_METER
			).pad_decimals(2);
	)
