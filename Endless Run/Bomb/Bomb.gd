extends Area2D
class_name Bomb

const INVENTORY_LOST_PERCENTAGE: float = 0.2;

func _on_body_entered(body):
	if !(body is Drill):
		return;
	var drill: Drill = body;
	
	self.get_parent().call_deferred("remove_child", self);
	BombManager.addToPool(self);
	
	SignalBus_EndlessRun.bomb_explode.emit();
	
	if (drill.armor >= 0):
		return;
	
	var oreTypes: Array[Ore.EOreType] = [];		# This will be used when randomizing which ores are lost
	var totalOres: int = 0;
	for oreType: Ore.EOreType in drill.inventory.keys():
		var oreCount: int = drill.inventory[oreType];
		if (oreCount == 0):
			continue;
		totalOres += oreCount;
		oreTypes.append(oreType);
	
	#region Randomize which ores are lost
	### 1. Randomly choose what ore type is lost from oreTypes
	### 2. If there's only 1 ore type in oreTypes, lose that ore type, and skip the next steps
	### 3. Randomize the amount that is lost
	### 4. If the amount of that ore type is 0, remove it from oreTypes
	### 5. Repeat until lostOreCount reaches 0
	
	var lostOreCount: int = int(self.INVENTORY_LOST_PERCENTAGE * totalOres);
	var lostOres: Dictionary = {
		Ore.EOreType.Ore1: 0,
		Ore.EOreType.Ore2: 0,
		Ore.EOreType.Ore3: 0,
	};
	while lostOreCount > 0:
		var thisBatchLostCount: int = lostOreCount;
		var lostOreType: Ore.EOreType = oreTypes[0];
		if (oreTypes.size() > 1):
			lostOreType = oreTypes[randi_range(0, oreTypes.size() - 1)];
			thisBatchLostCount = min(
				randi_range(1, lostOreCount),
				drill.inventory[lostOreType]
			);
		
		lostOres[lostOreType] += thisBatchLostCount;
		lostOreCount -= thisBatchLostCount;
		drill.inventory[lostOreType] -= thisBatchLostCount;
		if (drill.inventory[lostOreType] == 0):
			oreTypes.erase(lostOreType);
	#endregion
	
	drill._isDocked = true;
	SignalBus_EndlessRun.drill_explode.emit(lostOres);
	for oreType: Ore.EOreType in drill.inventory.keys():
		drill.inventory[oreType] = 0;
