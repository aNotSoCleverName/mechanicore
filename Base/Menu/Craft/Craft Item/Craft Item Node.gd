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

func _RefreshTimeLabel():
	$MarginContainer/HBoxContainer/Details/Time/Label.text = str(
		self.craftItem.timeSec * (1 - self._base.stats[Upgrade.EStatsKeys.base_ShortenCraftTime])
	).pad_decimals(1) + "s";

func _ready() -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/Icon.texture = self.craftItem.image;
	
	$MarginContainer/HBoxContainer/Details/Price/Label.text = str(self.craftItem.price);
	self._RefreshTimeLabel();
	
	self._DetermineCraftable();
	
	SignalBus_Base.update_inventory_ore.connect(
		func (_inCurrentInventory: Dictionary):
			self._DetermineCraftable();
	)
	SignalBus_Base.update_craft_queue.connect(
		func (_inCurrentQueueCount: int):
			self._DetermineCraftable();
	)
	SignalBus_Base.upgrade_base_shorten_craft_time.connect(
		func ():
			self._RefreshTimeLabel();
	)

func _on_button_pressed():
	SignalBus_Base.craft_queue.emit(self.craftItem);
	SoundList.get_node("Craft").play();
