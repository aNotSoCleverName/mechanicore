extends Node2D
class_name OreChunk

@export var width: int = 0;
@export var height: int = 0;

func _addOresToPool() -> void:
	for orePlaceholder: OrePlaceholder in self.get_children() as Array[OrePlaceholder]:
		var ore: Ore = orePlaceholder.get_child(1);
		if !(ore is Ore):
			continue;
		OreManager.addToPool(ore);
		orePlaceholder.remove_child(ore);

func _ready() -> void:
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (inPos: Vector2):
			var chunkBottom: float = self.position.y + self.height;
			var viewportTopY: float = inPos.y - GlobalProperty_EndlessRun.SURFACE_Y;
			
			if (chunkBottom >= viewportTopY):
				return;
			
			self._addOresToPool();
			self.queue_free();
	)
	
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, _inDrill: Drill):
			if (!inIsDocked):
				return;
			
			self._addOresToPool();
			self.queue_free();
	)
