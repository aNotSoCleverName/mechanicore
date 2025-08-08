extends Node2D
class_name OreChunk

@export var width: int = 0;
@export var height: int = 0;

const ORE_CHUNK_DIR_PATH: String = "res://Endless Run/Ores/Ore Chunk/";
static var _oreChunkFilePaths: PackedStringArray = [];

#region Public functions
enum EPossibleChunkRotation
{
	deg0 = 0,
	deg90 = 90,
	deg180 = 180,
	deg270 = 270,
}
static func GenerateOreChunk(inPos: Vector2) -> OreChunk:
	OreChunk._InitOreChunkFilePaths();
	
	var loadedChunkIndex: int = randi_range(0, OreChunk._oreChunkFilePaths.size() - 1);
	var loadedChunk: OreChunk = load(OreChunk._oreChunkFilePaths[loadedChunkIndex]).instantiate();
	
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
static func _InitOreChunkFilePaths():
	if (OreChunk._oreChunkFilePaths.size() > 0):	# If already initiated
		return;
	
	var dir: DirAccess = DirAccess.open(OreChunk.ORE_CHUNK_DIR_PATH);
	var fileNames: PackedStringArray = dir.get_files();
	
	var i: int = 0;
	while i < fileNames.size():
		var fileName: String = fileNames[i];
		if (fileName.ends_with(".tscn")):
			fileNames[i] = OreChunk.ORE_CHUNK_DIR_PATH + fileName;
			i += 1;
			continue;
		
		fileNames.remove_at(i);
	OreChunk._oreChunkFilePaths = fileNames;

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
