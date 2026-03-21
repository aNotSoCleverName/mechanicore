extends PanelContainer
class_name Main

static var IS_SKIP_TUTORIAL: bool = OS.is_debug_build() && true;
static var IS_CHEAT_ORE: bool = OS.is_debug_build() && true;
static var IS_CHEAT_MONEY: bool = OS.is_debug_build() && true;

func _on_tree_entered():
	SignalBus_Base.game_over.connect(
		func ():
			var gameOver: Control = preload("res://Game Over.tscn").instantiate();
			self.add_child(gameOver);
	)
