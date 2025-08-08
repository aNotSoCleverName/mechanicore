extends Panel
class_name CraftItemNode;

@export var craftItem: CraftItem;

@onready var _base: Base = self.find_parent("Base");
@onready var materialsNode: VBoxContainer = $MarginContainer/HBoxContainer/Details/Materials;
@onready var _craftButton: TextureButton = $MarginContainer/HBoxContainer/Craft/Button;

func _DetermineCraftable():
	self._craftButton.disabled = false;
	
	if (
		self._base._currentCraftQueueCount >=
		self._base.DEFAULT_MAX_CRAFT_QUEUE + self._base.stats[Upgrade.EStatsKeys.base_MaxCraftQueue]
	):
		self._craftButton.disabled = true;
		return;
	
	for oreType: Ore.EOreType in self.craftItem.materials.keys():
		var oreNode: CraftItemMaterial = materialsNode.find_child("Ore" + str(oreType));
		if (oreNode == null):
			continue;
					
		if (oreNode.stock < oreNode.requirement):
			self._craftButton.disabled = true;
			return;

func _ready() -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/Icon.texture = self.craftItem.image;
	
	$MarginContainer/HBoxContainer/Details/Price/Label.text = str(self.craftItem.price);
	$MarginContainer/HBoxContainer/Details/Time/Label.text = str(self.craftItem.timeSec).pad_decimals(1) + "s"
	
	# Show material requirement on UI
	for oreType: Ore.EOreType in self.craftItem.materials.keys():
		var oreNode: CraftItemMaterial = materialsNode.find_child("Ore" + str(oreType));
		if (self.craftItem.materials[oreType] == 0):
			oreNode.queue_free();
		else:
			oreNode.requirement = self.craftItem.materials[oreType];
	
	self._DetermineCraftable();
	
	SignalBus_Base.update_ore_inventory.connect(
		func (inCurrentInventory: Dictionary):
			# Update stock
			for oreType: Ore.EOreType in self.craftItem.materials.keys():
				var oreNode: CraftItemMaterial = materialsNode.find_child("Ore" + str(oreType));
				if (oreNode == null):
					continue;
				oreNode.stock = inCurrentInventory[oreType];
			
			self._DetermineCraftable();
	)
	SignalBus_Base.update_craft_queue.connect(
		func (_inCurrentQueueCount: int):
			self._DetermineCraftable();
	)

func _on_button_pressed():
	SignalBus_Base.craft_queue.emit(self.craftItem);
