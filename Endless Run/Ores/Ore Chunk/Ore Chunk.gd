extends Node2D
class_name OreChunk

@export var width: int = 0;
@export var height: int = 0;

static var _oreChunkResources: Array[Resource] = [];

#region Public functions
enum EPossibleChunkRotation
{
	deg0 = 0,
	deg90 = 90,
	deg180 = 180,
	deg270 = 270,
}
static func GenerateOreChunk(inPos: Vector2) -> OreChunk:
	UtilityInit.InitArrayFromFiles(OreChunk._oreChunkResources, "res://Endless Run/Ores/Ore Chunk/", ".tscn", true, false);
	
	var loadedChunkIndex: int = randi_range(0, OreChunk._oreChunkResources.size() - 1);
	var loadedChunk: OreChunk = OreChunk._oreChunkResources[loadedChunkIndex].instantiate();
	
	loadedChunk.position = inPos;
	loadedChunk.rotation_degrees = OreChunk.EPossibleChunkRotation.values()[randi_range(0, OreChunk.EPossibleChunkRotation.values().size() - 1)];
	if (
		loadedChunk.rotation_degrees == OreChunk.EPossibleChunkRotation.deg90 ||
		loadedChunk.rotation_degrees == OreChunk.EPossibleChunkRotation.deg270
	):
		var tempWidth: int = loadedChunk.width;
		loadedChunk.width = loadedChunk.height;
		loadedChunk.height = tempWidth;
	
	return loadedChunk;
#endregion

#region Private functions
func _addOresToPool() -> void:
	for orePlaceholder: OrePlaceholder in self.get_children() as Array[OrePlaceholder]:
		var ore: Ore = orePlaceholder.get_child(1);
		if !(ore is Ore):
			continue;
		OreManager.addToPool(ore);
#endregion

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
