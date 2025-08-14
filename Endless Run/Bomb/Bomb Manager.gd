extends Node2D
class_name BombManager;

const BOMB_START_DEPTH: float = 100;
const BOMB_START_CHANCE: float = 0.05;

const BOMB_COMMON_DEPTH: float = 1000;
const BOMB_COMMON_CHANCE: float = 0.15;

var bombPool: Array[Bomb] = [];
func addToPool(inBomb: Bomb) -> void:
	self.call_deferred("remove_child", inBomb);
	self.bombPool.append(inBomb);
func _popFromPool() -> Bomb:
	return self.bombPool.pop_back();

@onready var _drill: Drill = GlobalProperty_EndlessRun.GetDrillNode(self);

func _on_tree_entered():
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, _inDrill: Drill):
			if (!inIsDocked):
				return;
			
			# Slice because first child is spawn timer
			for bomb: Bomb in self.get_children().slice(1) as Array[Bomb]:
				self.addToPool(bomb);
	)

func _process(_delta):
	if (self._drill.depth < self.BOMB_START_DEPTH):
		return;
	
	var spawnChance: float = BOMB_COMMON_CHANCE;
	if (self._drill.depth < self.BOMB_COMMON_DEPTH):
		spawnChance = lerp(
			self.BOMB_START_CHANCE,
			self.BOMB_COMMON_CHANCE,
			(self._drill.depth - self.BOMB_START_DEPTH)/(self.BOMB_COMMON_DEPTH - self.BOMB_START_DEPTH)
		);
	
	if (randf() > spawnChance):
		return;
	
	var bomb: Bomb = self._popFromPool();
	if (bomb == null):
		bomb = preload("res://Endless Run/Bomb/Bomb.tscn").instantiate();
	
	bomb.position = Vector2(
		randf_range(0, GlobalProperty_EndlessRun.VIEWPORT_SIZE.x),
		self._drill.position.y + GlobalProperty_EndlessRun.VIEWPORT_SIZE.y
	);
	
	self.add_child(bomb);
