extends HBoxContainer

var _isShowingTutorial_PickOre: bool = false;

func _ready():
	SignalBus_EndlessRun.ore_pick.connect(
		self._ShowPickOreTutorial
	)

func _ShowPickOreTutorial(_inOre: Ore):
	SignalBus_EndlessRun.ore_pick.disconnect(
		self._ShowPickOreTutorial
	)
	self._isShowingTutorial_PickOre = true;
	
	SignalBus_Tutorial.show_tutorial.emit(
		self,
		"You just picked an ore. It is now stored in the drill's inventory",
	);
