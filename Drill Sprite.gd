extends Sprite2D

func _ready() -> void:
	SignalBus_EndlessRun.drill_change_dir.connect(
		func (inDir: SignalBus_EndlessRun.EDrillDirection):
			rotation = deg_to_rad(inDir);
	);
