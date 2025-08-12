extends HBoxContainer

func _ready():
	SignalBus_EndlessRun.ore_pick.connect(
		self._ShowPickOreTutorial
	)
	
	SignalBus_EndlessRun.drill_change_dock.connect(
		self._ShowDockTutorial
	)

func _ShowPickOreTutorial(_inOre: Ore):
	SignalBus_EndlessRun.ore_pick.disconnect(
		self._ShowPickOreTutorial
	)
	
	SignalBus_Tutorial.hasPickedOre = true;
	
	SignalBus_Tutorial.show_tutorial.emit(
		self,
		"You just picked an ore. It is now stored in the drill's inventory",
	);

func _ShowDockTutorial(inIsDocked: bool, _inDrill: Drill):
	if (!inIsDocked):
		return;
	
	if (!SignalBus_Tutorial.hasPickedOre):
		return;
	
	SignalBus_EndlessRun.drill_change_dock.disconnect(
		self._ShowDockTutorial
	)
	
	SignalBus_Tutorial.show_tutorial.emit(
		self,
		"The ore you've collected will be transfered to the [i]base[/i] when you return to the surface",
	)
	
	await SignalBus_Tutorial.hide_tutorial;
	
	SignalBus_Tutorial.add_craft_tab.emit();
