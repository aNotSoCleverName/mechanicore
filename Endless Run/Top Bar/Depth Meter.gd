extends Label

func _on_tree_entered():
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (_inPos: Vector2, inDrill: Drill):
			self.text = "Depth: " + str(inDrill.depth).pad_decimals(2) + "m";
	)
