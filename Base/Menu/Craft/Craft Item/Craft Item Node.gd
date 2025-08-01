extends Panel
class_name CraftItemNode;

@export var craftItem: CraftItem;

@onready var _craftButton: Button = $MarginContainer/HBoxContainer/Craft/Button;

func _ready() -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/Icon.texture = self.craftItem.image;
	
	$MarginContainer/HBoxContainer/Details/Price/Label.text = str(self.craftItem.price);
	$MarginContainer/HBoxContainer/Details/Time/Label.text = str(self.craftItem.timeSec).pad_decimals(2) + "s"
	
	var materialsNode: VBoxContainer = $MarginContainer/HBoxContainer/Details/Materials;
	
	self._craftButton.disabled = false;
	for oreType: Ore.EOreType in self.craftItem.materials.keys():
		var oreNode: CraftItemMaterial = materialsNode.find_child("Ore" + str(oreType));
		
		if (self.craftItem.materials[oreType] == 0):
			oreNode.queue_free();
			continue;
		
		oreNode.requirement = self.craftItem.materials[oreType];
		if (oreNode.stock < oreNode.requirement):
				self._craftButton.disabled = true;
	
	SignalBus_Base.update_ore_inventory.connect(
		func (inCurrentInventory: Dictionary):
			self._craftButton.disabled = false;
			for oreType: Ore.EOreType in self.craftItem.materials.keys():
				var oreNode: CraftItemMaterial = materialsNode.find_child("Ore" + str(oreType));
				if (oreNode == null):
					continue;
				
				oreNode.stock = inCurrentInventory[oreType];
				if (oreNode.stock < oreNode.requirement):
					self._craftButton.disabled = true;
	)

func _on_button_pressed():
	SignalBus_Base.craft_queue.emit(self.craftItem);
