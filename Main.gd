extends PanelContainer

func _on_tree_entered():
	SignalBus_Base.game_over.connect(
		func ():
			var gameOver: Control = preload("res://Game Over.tscn").instantiate();
			self.add_child(gameOver);
	)
