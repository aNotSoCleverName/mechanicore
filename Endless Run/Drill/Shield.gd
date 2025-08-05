extends Sprite2D

const SHADER_KEY_MAX_SHIELD: String = "maxShield";
const SHADER_KEY_SHIELD: String = "shield";

func _ready():
	self.self_modulate.a = 0;
	var shader: ShaderMaterial = self.material;
	
	var maxShieldUpgrade: Resource = preload("res://Base/Menu/Upgrade/Resource/Max Shield.tres");
	shader.set_shader_parameter(
		SHADER_KEY_MAX_SHIELD,
		maxShieldUpgrade.maxLevel,
	);
	
	var turnOnTimer: Timer = $"Turn On Timer";
	turnOnTimer.timeout.connect(
		func ():
			self.self_modulate.a = min(1, self.self_modulate.a + 0.1);
			if (self.self_modulate.a >= 1):
				turnOnTimer.stop();
	)
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, _inDrill: Drill):
			if (inIsDocked):
				self.self_modulate.a = 0;
				return;
			
			turnOnTimer.start();
	)
	
	SignalBus_EndlessRun.update_drill_shield.connect(
		func (inDrill: Drill):
			shader.set_shader_parameter(SHADER_KEY_SHIELD, inDrill.shield);
	)
