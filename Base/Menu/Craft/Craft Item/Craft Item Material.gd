@tool
extends HBoxContainer
class_name CraftItemMaterial

@export var icon: Texture2D:
	set(inValue):
		icon = inValue;
		
		if (self._textureRect != null):
			self._textureRect.texture = icon;

var requirement: int:
	set(inValue):
		requirement = inValue;
		
		if (self._requirementNode != null):
			self._requirementNode.text = str(requirement);

var stock: int:
	set(inValue):
		stock = inValue;
		self._AdjustRequirementColor();
		
		if (self._stockNode != null):
			self._stockNode.text = str(stock);

@onready var _textureRect: TextureRect = $TextureRect;
@onready var _requirementNode: Label = $Requirement;
@onready var _stockNode: Label = $Stock;

func _AdjustRequirementColor() -> void:
	if (self.stock < self.requirement):
		self._requirementNode.self_modulate = Color.RED;
	else:
		self._requirementNode.self_modulate = Color.WHITE;

func _ready() -> void:
	self._textureRect.texture = self.icon;
	self._requirementNode.text = str(self.requirement);
	self._stockNode.text = str(self.stock);
	
	self._AdjustRequirementColor();
