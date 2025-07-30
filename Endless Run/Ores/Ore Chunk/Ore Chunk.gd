extends Node2D
class_name OreChunk

@export var width: int = 0;
@export var height: int = 0;

func _ready() -> void:
	# queue_free() when no longer visible
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (inPos: Vector2):
			var chunkBottom: float = self.position.y + self.height;
			var viewportTopY: float = inPos.y - GlobalProperty_EndlessRun.SURFACE_Y;
			
			if (chunkBottom >= viewportTopY):
				return;
			
			self.queue_free();
	)
