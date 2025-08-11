@tool
extends HBoxContainer
class_name CraftItemMaterial

@export var oreType: Ore.EOreType = Ore.EOreType.Ore1;

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

@onready var _base: Base = self.find_parent("Base");
var _craftItemNode: CraftItemNode;

func _AdjustRequirementColor() -> void:
	if (self.stock < self.requirement):
		self._requirementNode.self_modulate = Color.RED;
	else:
		self._requirementNode.self_modulate = Color.WHITE;

func _ready() -> void:
	var ancestorNode: Node = self.get_parent();
	while !(ancestorNode is CraftItemNode):
		ancestorNode = ancestorNode.get_parent();
	self._craftItemNode = ancestorNode;
	
	self.requirement = self._craftItemNode.craftItem.materials[self.oreType];
	if (self.requirement == 0):
		self.queue_free();
	
	self.stock = self._base.ores[self.oreType];
	
	self._textureRect.texture = load("res://Endless Run/Ores/Ore" + str(self.oreType) + ".png");
	
	self._AdjustRequirementColor();
	
	SignalBus_Base.update_inventory_ore.connect(
		func (inCurrentInventory: Dictionary):
			self.stock = inCurrentInventory[self.oreType];
	)
