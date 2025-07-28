extends Area2D

@export var bounceDir: SignalBus_EndlessRun.EDrillDirection = SignalBus_EndlessRun.EDrillDirection.DOCKED;

var _drill: Drill;

func _ready() -> void:
	self._drill = self.find_parent("Endless Run").find_child("Drill");

func _process(_delta):
	self.global_position.y = self._drill.global_position.y - 256;

func _on_body_entered(body: Drill):
	if (body != self._drill):
		return;
	
	self._drill._directionDeg = self.bounceDir;
