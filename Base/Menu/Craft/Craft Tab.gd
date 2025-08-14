extends VBoxContainer

@onready var _base: Base = self.find_parent("Base");

func _ready():
	self._base.craftItemContainer = $"Craft Items MarginContainer/ScrollContainer/MarginContainer/Craft Items";
	
	# Initiate craftItems
	var craftItems: Array[CraftItem] = [];
	UtilityInit.InitArrayFromFiles(craftItems, self._base.CRAFT_ITEM_RESOURCES_DIR, ".tres", true, false);
	
	for craftItem: CraftItem in craftItems:
		if (
			craftItem.materials[Ore.EOreType.Ore2] > 0 ||
			craftItem.materials[Ore.EOreType.Ore3] > 0
		):
			continue;
		self._base.AddCraftItem(craftItem);
	
	SignalBus_Base.craft_queue.connect(
		func (_inCraftItem: CraftItem):
			$"SFX Craft".play();
	)
