extends VisibleOnScreenNotifier2D

static var hasShownTutorial: bool = false;

func _on_screen_entered():
	if (hasShownTutorial):
		self.queue_free();
		return;
	hasShownTutorial = true;
	
	SignalBus_Tutorial.show_tutorial.emit(
		self.get_parent(),
		"Watch out for blackholes! If we hit a blackhole and break our drill, we'll be forced to return to the surface, and lose some of the ores our drill has collected"
	)
