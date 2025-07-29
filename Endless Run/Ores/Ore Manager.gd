extends Node2D

# key = Ore.EOreType, value = Array[Ore]
var orePools: Dictionary = { }:
	get:
		return orePools;
func _addToPool(inOre: Ore) -> void:
	var orePool: Array[Ore] = self.orePools[inOre.oreType];
	orePool.append(inOre);
func _popFromPool(inOreType: Ore.EOreType) -> Ore:
	var orePool: Array[Ore] = self.orePools[inOreType];
	return orePool.pop_back();

func _on_tree_entered() -> void:
	# Initiate dictionary
	for type in Ore.EOreType.values():
		var tempArrOfOre: Array[Ore] = [];
		orePools[type] = tempArrOfOre;
	
	SignalBus_EndlessRun.ore_pick.connect(
		func (inOre: Ore):
			self._addToPool(inOre);
			var orePlaceholder: OrePlaceholder = inOre.get_parent();
			orePlaceholder.call_deferred("remove_child", inOre);
			orePlaceholder.queue_free();
	)
	
	SignalBus_EndlessRun.ore_place.connect(
		func (inOrePlaceholder: OrePlaceholder):
			var ore: Ore = self._popFromPool(inOrePlaceholder.oreType);
			if (ore == null):
				ore = preload("res://Endless Run/Ores/Ore.tscn").instantiate();
				ore.oreType = inOrePlaceholder.oreType;
			inOrePlaceholder.add_child(ore);
	)

#func _placeOre(inOrePlaceholder: OrePlaceholder) -> void:
	#var ore: Ore = self._popFromPool(inOrePlaceholder.oreType);
	#if (ore == null):
		#ore = preload("res://Endless Run/Ores/Ore.tscn").instantiate();
		#ore.oreType = inOrePlaceholder.oreType;
	#inOrePlaceholder.add_child(ore);
