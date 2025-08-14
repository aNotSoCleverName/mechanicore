extends PanelContainer

var targetY: Array[int] = [0, -180, 0, -90, 0];
var changeY: Array[int] = [30, 20, 20, 10, 10]
var stageIndex: int = 0;

var gameNode: Node;

func _ready():
	self.get_tree().paused = true;
	self.position.y = -self.size.y;
	self.gameNode = self.get_parent().get_child(0);

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
	self.get_tree().paused = false;
	get_tree().reload_current_scene();
