extends Resource
class_name Upgrade

enum EStatsKeys
{
	maxShield,
	maxSpeed,
	doubleOreChance,
	dodge,
}
@export var stats: Upgrade.EStatsKeys;

@export var icon: Texture2D;
@export var name: String = "Name";

var level: int = 0;
@export var maxLevel: int = 3;

@export var statChange: Array[float] = [0, 0, 0];	# Size must be = maxLevel

@export var prices: Array[int] = [0, 0, 0];	# Size must be = maxLevel
