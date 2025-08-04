extends PanelContainer

var targetY: Array[int] = [0, -180, 0, -90, 0];
var changeY: Array[int] = [30, 20, 20, 10, 10]
var stageIndex: int = 0;

func _ready():
	self.position.y = -self.size.y;

func _process(_delta: float):
	if (self.stageIndex >= self.targetY.size()):
		return;
	
	if (self.position.y == self.targetY[self.stageIndex]):
		self.stageIndex += 1;
	elif (self.position.y < self.targetY[self.stageIndex]):
		self.position.y = min(self.position.y + self.changeY[self.stageIndex], self.targetY[self.stageIndex]);
	else:
		self.position.y = max(self.position.y - self.changeY[self.stageIndex], self.targetY[self.stageIndex]);

func _on_play_again_button_pressed():
	var main: Control = self.get_parent();
	main.get_child(0).queue_free();
	
	var newGame: HBoxContainer = preload("res://Game.tscn").instantiate();
	main.add_child(newGame);
	
	self.queue_free();
