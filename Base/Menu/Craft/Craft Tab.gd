extends VBoxContainer

@onready var _base: Base = self.find_parent("Base");

func _ready():
	self._base.craftItemContainer = $"Craft Items MarginContainer/ScrollContainer/MarginContainer/Craft Items";
	
	# Initiate craftItems
	for filePath: String in DirAccess.open(Base.CRAFT_ITEM_RESOURCES_DIR).get_files():
		if (!filePath.ends_with(".tres")):
			continue;
		
		var fullPath: String = Base.CRAFT_ITEM_RESOURCES_DIR + filePath;
		var craftItem: CraftItem = load(fullPath);
		if (
			craftItem.materials[Ore.EOreType.Ore2] > 0 ||
			craftItem.materials[Ore.EOreType.Ore3] > 0
		):
			continue;
		self._base.AddCraftItem(craftItem);
