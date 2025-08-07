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

#var _prevBombY: float = 0;
func _on_tree_entered():
	var drill: Drill = GlobalProperty_EndlessRun.GetDrillNode(self);
	
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, _inDrill: Drill):
			if (!inIsDocked):
				return;
			
			for bomb: Bomb in self.get_children() as Array[Bomb]:
				self.addToPool(bomb);
	)
	
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (inPos: Vector2):
			if (drill.depth < self.BOMB_START_DEPTH):
				return;
			
			var spawnChance: float = BOMB_COMMON_CHANCE;
			if (drill.depth < self.BOMB_COMMON_DEPTH):
				spawnChance = lerp(
					self.BOMB_START_CHANCE,
					self.BOMB_COMMON_CHANCE,
					(drill.depth - self.BOMB_START_DEPTH)/(self.BOMB_COMMON_DEPTH - self.BOMB_START_DEPTH)
				);
			
			if (randf() > spawnChance):
				return;
			
			var bomb: Bomb = self._popFromPool();
			if (bomb == null):
				bomb = preload("res://Endless Run/Bomb/Bomb.tscn").instantiate();
			
			bomb.position = Vector2(
				randf_range(0, GlobalProperty_EndlessRun.VIEWPORT_SIZE.x),
				inPos.y + GlobalProperty_EndlessRun.VIEWPORT_SIZE.y
				#self._prevBombY + randf_range()
			);
			#self._prevBombY = bomb.position.y;
			
			self.add_child(bomb);
	)
