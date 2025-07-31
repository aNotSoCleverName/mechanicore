extends Label

var _drill: Drill;

func _on_tree_entered():
	self._drill = GlobalProperty_EndlessRun.GetDrillNode(self);
	
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (_inPos: Vector2):
			self.text = "Depth: " + str(self._drill.depth).pad_decimals(2) + "m";
	)
