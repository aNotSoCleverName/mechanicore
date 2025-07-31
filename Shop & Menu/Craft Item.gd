extends Resource
class_name CraftItem

@export var id: int = 0;
@export var image: Texture2D;
@export var price: int;
@export var timeSec: float;

@export var materials: Dictionary = {
	Ore.EOreType.Ore1: 0,
	Ore.EOreType.Ore2: 0,
	Ore.EOreType.Ore3: 0,
}
