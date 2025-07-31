extends Area2D

@export var bounceDir: SignalBus_EndlessRun.EDrillDirection = SignalBus_EndlessRun.EDrillDirection.DOCKED;

var _drill: Drill;

func _ready() -> void:
	self._drill = GlobalProperty_EndlessRun.GetDrillNode(self);

func _process(_delta):
	self.global_position.y = self._drill.global_position.y - GlobalProperty_EndlessRun.SURFACE_Y;

func _on_body_entered(body: Drill):
	if (body != self._drill):
		return;
	
	self._drill._directionDeg = self.bounceDir;
