extends AnimatedSprite2D

func _ready() -> void:
	SignalBus_EndlessRun.drill_change_dir.connect(
		func (inDir: SignalBus_EndlessRun.EDrillDirection):
			rotation = deg_to_rad(inDir);
	);
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		play("drill_animation")
