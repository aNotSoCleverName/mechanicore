extends HBoxContainer

@export var icon: Texture2D;

func _ready() -> void:
	var iconNode: TextureRect = self.find_child("Icon");
	iconNode.texture = self.icon;
