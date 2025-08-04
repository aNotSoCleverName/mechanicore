extends Resource
class_name DrillUpgrade

@export var icon: Texture2D;
@export var name: String = "Name";

var level: int = 0;
@export var maxLevel: int = 3;

@export var prices: Array[int] = [0, 0, 0]; # Size must be = maxLevel
