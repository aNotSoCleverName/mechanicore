extends HBoxContainer

@export var oreType: Ore.EOreType = Ore.EOreType.Ore1;

func _ready() -> void:
	var iconNode: TextureRect = self.find_child("Icon");
	iconNode.texture = Ore.GetOreTexture(self.oreType);
