extends Node2D
class_name BombManager;

const BOMB_START_DEPTH: float = 100;
const BOMB_START_CHANCE: float = 0.01;

const BOMB_COMMON_DEPTH: float = 1000;
const BOMB_COMMON_CHANCE: float = 0.15;

var bombPool: Array[Bomb] = [];
func addToPool(inBomb: Bomb) -> void:
	self.call_deferred("remove_child", inBomb);
	self.bombPool.append(inBomb);
func _popFromPool() -> Bomb:
	return self.bombPool.pop_back();

@onready var _drill: Drill = GlobalProperty_EndlessRun.GetDrillNode(self);

var _prevBombY: float = 0;

func _on_tree_entered():
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, _inDrill: Drill):
			if (!inIsDocked):
				return;
			
			self._prevBombY = 0;
			for bomb: Bomb in self.get_children() as Array[Bomb]:
				self.addToPool(bomb);
	)

func _process(_delta):
	if (self._drill.depth < self.BOMB_START_DEPTH):
		return;
	
	# Don't generate too far away from player
	if (self._prevBombY > self._drill.position.y + (2 * GlobalProperty_EndlessRun.VIEWPORT_SIZE.y)):
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
		self._drill.position.y + GlobalProperty_EndlessRun.VIEWPORT_SIZE.y + self._prevBombY
	);
	self._prevBombY += bomb._size.y + randi_range(
		0,
		max(
			bomb._size.y * (3 - max(1, BombManager.BOMB_COMMON_DEPTH - self._drill.depth)/(BombManager.BOMB_COMMON_DEPTH - BombManager.BOMB_START_DEPTH)),
			BombManager.BOMB_COMMON_DEPTH - self._drill.depth
		)
	);
	
	self.add_child(bomb);
