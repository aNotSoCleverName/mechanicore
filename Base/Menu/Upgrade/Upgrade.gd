extends Resource
class_name Upgrade

enum EUpgradeTarget
{
	none,
	drill,
	base,
}
@export var upgradeTarget: EUpgradeTarget;

enum EStatsKeys
{
	none,
	
	drill_MaxShield,
	drill_MaxSpeed,
	drill_DoubleOreChance,
	drill_Dodge,
	
	base_MaxCraftQueue,
	base_MindReader,
	base_ShortenCraftTime,
}
@export var stats: EStatsKeys;

@export var icon: Texture2D;
@export var name: String = "Name";

var level: int = 0;
@export var maxLevel: int = 3;

@export var statChange: Array[float] = [0, 0, 0];	# Size must be = maxLevel

@export var prices: Array[int] = [0, 0, 0];	# Size must be = maxLevel

### Unit to be shown in desc
### E.g: Max speed is shown in m/s, and max armor doesn't have a unit
@export var descStatUnit: String;

### Multiplier to be shown in desc
### E.g: Max speed is calculated by the hundreds (100px/s)
### Because of this, the statChanges are stored in hundreds too
### But to make it easier to understand by the player, we show it as m/s
### If 1m = 100px, then we want to convert 100px/s to 1m/s
### Meaning, descStatMult should be 1/100
@export var descStatMult: float = 1;

@export var desc: String:
	get:
		var formattedDesc: String = desc;
		
		var totalStatChange: float = 0;
		for i: int in self.level + 1:
			totalStatChange += self.statChange[i];
		totalStatChange *= self.descStatMult;
		formattedDesc = formattedDesc.replace("${totalStatChange}", str(totalStatChange) + self.descStatUnit);
		
		var nextLevelStatChange: float = self.statChange[self.level] * self.descStatMult;
		if (nextLevelStatChange == totalStatChange):
			formattedDesc = formattedDesc.replace(" ${statChange}", "");
		else:
			formattedDesc = formattedDesc.replace(
				" ${statChange}",
				" ([color=green]+" + str(nextLevelStatChange) + "[/color]" + self.descStatUnit + ")"
			);
		
		return formattedDesc;
