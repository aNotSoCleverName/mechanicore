extends Node2D
class_name OrePlaceholder

@export var oreType: Ore.EOreType = Ore.EOreType.Ore1;

func _ready() -> void:
	var drill: Drill = GlobalProperty_EndlessRun.GetDrillNode(self);
	self._RandomizeOreType(drill.depth);
	
	SignalBus_EndlessRun.ore_place.emit(self);

#region Randomize ore type
var _ore2Start: float = 400;
var _ore2Common: float = 700;
var _ore3Start: float = 1500;
var _ore3Common: float = 3000;
func _RandomizeOreType(inDepth: float) -> void:
	## Key = ore type, value = weight
	var oreTypeWeights: Dictionary = { };
	
	# Ore1
	if (inDepth < self._ore2Start):
		self.oreType = Ore.EOreType.Ore1;
		return;
	elif (inDepth < self._ore3Common):
		oreTypeWeights[Ore.EOreType.Ore1] = self._GetOreTypeWeightFromLerp(inDepth, 0.33, self._ore3Common, 1, self._ore2Start);
	else:
		oreTypeWeights[Ore.EOreType.Ore1] = 0.33;
	
	# Ore2
	if (inDepth < self._ore2Common):
		oreTypeWeights[Ore.EOreType.Ore2] = self._GetOreTypeWeightFromLerp(inDepth, 0, self._ore2Start, 1, self._ore2Common);
	elif (inDepth < self._ore3Start):
		oreTypeWeights[Ore.EOreType.Ore2] = 1;
	elif (inDepth < self._ore3Common):
		oreTypeWeights[Ore.EOreType.Ore2] = self._GetOreTypeWeightFromLerp(inDepth, 0.33, self._ore3Common, 1, self._ore2Common);
	else:
		oreTypeWeights[Ore.EOreType.Ore2] = 0.33;
	
	# Ore3
	if (inDepth < self._ore3Start):
		oreTypeWeights[Ore.EOreType.Ore3] = 0;
	elif (inDepth < self._ore3Common):
		oreTypeWeights[Ore.EOreType.Ore3] = self._GetOreTypeWeightFromLerp(inDepth, 0, self._ore3Start, 0.33, self._ore3Common);
	else:
		oreTypeWeights[Ore.EOreType.Ore3] = 0.33;
	
	var totalWeights: float = 0
	for weight: float in oreTypeWeights.values():
		totalWeights += weight;
	
	var rolledFloat: float = randf_range(0, totalWeights);
	
	var accumulatedWeight: float = 0;
	for key: Ore.EOreType in oreTypeWeights.keys():
		accumulatedWeight += oreTypeWeights[key];
		if (rolledFloat < accumulatedWeight):
			self.oreType = key;
			return;

func _GetOreTypeWeightFromLerp(inDepth: float, inMinWeight: float, inMinWeightDepth: float, inMaxWeight: float, inMaxWeightDepth: float):
	return (inMinWeight - inMaxWeight)/(inMinWeightDepth - inMaxWeightDepth) * (inDepth - inMaxWeightDepth) + inMaxWeight;
#endregion

func _on_child_exiting_tree(node):
	if (!(node is Ore)):
		return;
	self.queue_free();
