extends Control

@onready var _drill: Drill = self.find_child("Drill", true);

func _on_tree_entered():
	SignalBus_Base.game_over.connect(
		func ():
			var gameOver: Control = preload("res://Game Over.tscn").instantiate();
			self.add_child(gameOver);
	)

func _ready():
	SignalBus_Tutorial.show_tutorial.emit(
		self._drill,
		"Press SPACE to start digging",
		0.1
	);

func _input(event: InputEvent):
	if !(event is InputEventKey):
		return;
	
	if !(SignalBus_Tutorial.hasStartedDigging):
		if !(event.is_action_released("ui_accept")):
			return;
		
		SignalBus_Tutorial.hasStartedDigging = true;
		SignalBus_Tutorial.hide_tutorial.emit();
		return;
