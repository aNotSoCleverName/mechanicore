extends Node2D
class_name OreManager

#region Properties
const ORE_CHUNK_DIR_PATH: String = "res://Endless Run/Ores/Ore Chunk";
var _oreChunkFilePaths: PackedStringArray = [];

var _drill: Drill;

# key = Ore.EOreType, value = Array[Ore]
static var orePools: Dictionary = { };
static func addToPool(inOre: Ore) -> void:
	var orePool: Array[Ore] = OreManager.orePools[inOre.oreType];
	orePool.append(inOre);
	
	inOre.get_parent().call_deferred("remove_child", inOre);
static func popFromPool(inOreType: Ore.EOreType) -> Ore:
	var orePool: Array[Ore] = OreManager.orePools[inOreType];
	return orePool.pop_back();
#endregion

#region Built-in functions
var _prevLoadedChunkY: float = 0;
func _on_tree_entered() -> void:
	#region Handle ore pooling
	# Initiate dictionary
	for type in Ore.EOreType.values():
		var tempArrOfOre: Array[Ore] = [];	# To set static type
		OreManager.orePools[type] = tempArrOfOre;
	
	SignalBus_EndlessRun.ore_pick.connect(
		func (inOre: Ore):
			self.addToPool(inOre);
	)
	
	SignalBus_EndlessRun.ore_place.connect(
		func (inOrePlaceholder: OrePlaceholder):
			var ore: Ore = self.popFromPool(inOrePlaceholder.oreType);
			if (ore == null):
				ore = preload("res://Endless Run/Ores/Ore.tscn").instantiate();
				ore.oreType = inOrePlaceholder.oreType;
			inOrePlaceholder.add_child(ore);
	)
	#endregion
	
	#region Handle ore generation
	self._initOreChunkFilePaths();
	
	const chanceToNotGenerate: float = 0.2;
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (inPos: Vector2):
			# Don't generate too far away from player
			if (self._prevLoadedChunkY > inPos.y + (2 * GlobalProperty_EndlessRun.VIEWPORT_SIZE.y)):
				return;
			
			if (randf() < chanceToNotGenerate):
				return;
			
			var chunkCenter: Vector2 = Vector2(
				randf() * GlobalProperty_EndlessRun.VIEWPORT_SIZE.x,
				GlobalProperty_EndlessRun.VIEWPORT_SIZE.y + GlobalProperty_EndlessRun.SURFACE_Y + self._prevLoadedChunkY,
			);
			
			var loadedChunk: OreChunk = self._generateOreChunk(chunkCenter);
			if (loadedChunk == null):
				return;
			self._prevLoadedChunkY += loadedChunk.height;
	)
	SignalBus_EndlessRun.drill_change_dock.connect(	# Reset ore generation when docking
		func (inIsDocked: bool, _inDrill: Drill):
			if (!inIsDocked):
				return;
			
			self._prevLoadedChunkY = 0;
	)
	#endregion
#endregion

#region Private functions
func _initOreChunkFilePaths():
	var dir: DirAccess = DirAccess.open(self.ORE_CHUNK_DIR_PATH);
	var fileNames: PackedStringArray = dir.get_files();
	
	var i: int = 0;
	while i < fileNames.size():
		var fileName: String = fileNames[i];
		if (fileName.ends_with(".tscn")):
			fileNames[i] = self.ORE_CHUNK_DIR_PATH + "/" + fileName;
			i += 1;
			continue;
		
		fileNames.remove_at(i);
	self._oreChunkFilePaths = fileNames;
	
var _possibleRotations: Array[int] = [0, 90, 180, 270];
func _generateOreChunk(inTopLeft: Vector2) -> OreChunk:
	var loadedChunkIndex: int = randi_range(0, self._oreChunkFilePaths.size() - 1);
	var loadedChunk: OreChunk = load(self._oreChunkFilePaths[loadedChunkIndex]).instantiate();
	
	loadedChunk.position = inTopLeft;
	loadedChunk.rotation_degrees = self._possibleRotations[randi_range(0, self._possibleRotations.size() - 1)];
	
	self.add_child(loadedChunk);
	return loadedChunk;
#endregion

func _ready() -> void:
	self._drill = self.find_parent("Endless Run").find_child("Drill");

#func _placeOre(inOrePlaceholder: OrePlaceholder) -> void:
	#var ore: Ore = self._popFromPool(inOrePlaceholder.oreType);
	#if (ore == null):
		#ore = preload("res://Endless Run/Ores/Ore.tscn").instantiate();
		#ore.oreType = inOrePlaceholder.oreType;
	#inOrePlaceholder.add_child(ore);
