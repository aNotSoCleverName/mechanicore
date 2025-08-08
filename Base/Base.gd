extends VBoxContainer
class_name Base

const CRAFT_ITEM_RESOURCES_DIR: String = "res://Base/Menu/Craft/Craft Item/Resources/";
const DEFAULT_MAX_CRAFT_QUEUE: int = 3;

var _currentCraftQueueCount: int = 0:
	get:
		return _currentCraftQueueCount;
	set(inValue):
		_currentCraftQueueCount = inValue;
		SignalBus_Base.update_craft_queue.emit(_currentCraftQueueCount);

# Key = Upgrade.EStatsKey, value = stats from upgrade
var stats: Dictionary = {
	Upgrade.EStatsKeys.base_MaxCraftQueue: 0,
	Upgrade.EStatsKeys.base_MindReader: 0,
}
func _UpdateStats(inKey: Upgrade.EStatsKeys, inValue: float):
	self.stats[inKey] = inValue;
	
	match inKey:
		Upgrade.EStatsKeys.base_MindReader:
			SignalBus_Base.upgrade_base_mind_reader_unlocked.emit();

# Key = ore type, value = amount
var ores: Dictionary = { };
func _addOres(inOres: Dictionary):
	for oreType: Ore.EOreType in ores.keys():
		self.ores[oreType] += inOres[oreType];
	SignalBus_Base.update_ore_inventory.emit(ores);
func _takeOres(inOres: Dictionary):
	for oreType: Ore.EOreType in ores.keys():
		self.ores[oreType] -= inOres[oreType];
	SignalBus_Base.update_ore_inventory.emit(ores);

@onready var _craftItemContainer: VBoxContainer = $"Menu/Craft/Craft Items MarginContainer/ScrollContainer/MarginContainer/Craft Items";
# Key = craftItem, value = amount
var craftItems: Dictionary = { };
func AddCraftItem(inKey: CraftItem):
	self.craftItems[inKey] = 0;
	
	var craftItemNode: CraftItemNode = preload("res://Base/Menu/Craft/Craft Item/Craft Item Node.tscn").instantiate();
	craftItemNode.craftItem = inKey;
	self._craftItemContainer.add_child(craftItemNode);

var money: int = 100000:
	get:
		return money;
	set(inValue):
		money = inValue;
		SignalBus_Base.update_inventory_money.emit(money);

func _on_tree_entered() -> void:
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, inDrill: Drill):
			if (!inIsDocked):
				return;
			
			self._addOres(inDrill.inventory);
	)
	
	SignalBus_Base.craft_queue.connect(
		func (inCraftItem: CraftItem):
			self._currentCraftQueueCount += 1;
			self._takeOres(inCraftItem.materials);
	);
	
	SignalBus_Base.craft_finished.connect(
		func (inCraftItem: CraftItem):
			self._currentCraftQueueCount -= 1;
			self.craftItems[inCraftItem] += 1;
	);
	
	SignalBus_Base.craft_cancel.connect(
		func (inCraftItem: CraftItem):
			self._currentCraftQueueCount -= 1;
			self._addOres(inCraftItem.materials);
	);
	
	SignalBus_Base.shop_sell.connect(
		func (inCraftItem: CraftItem):
			self.craftItems[inCraftItem] -= 1;
			self.money += inCraftItem.price;
	)
	
	SignalBus_Base.upgrade_drill.connect(
		func (inPrice: int, _inStatsKey: Upgrade.EStatsKeys, _inStatsChange: float):
			self.money -= inPrice;
	)
	
	SignalBus_Base.upgrade_base.connect(
		func (inPrice: int, inStatsKey: Upgrade.EStatsKeys, inStatsChange: float):
			self.money -= inPrice;
			self._UpdateStats(inStatsKey, self.stats[inStatsKey] + inStatsChange);
	)

func _ready() -> void:
	# Initiate ores
	for oreType: Ore.EOreType in Ore.EOreType.values():
		self.ores[oreType] = 0;
	SignalBus_Base.update_ore_inventory.emit(self.ores);	# This triggers the code that checks if craft item text should be red/white depending on stock
	
	# Initiate craftItems
	for filePath: String in DirAccess.open(CRAFT_ITEM_RESOURCES_DIR).get_files():
		if (!filePath.ends_with(".tres")):
			continue;
		
		var fullPath: String = CRAFT_ITEM_RESOURCES_DIR + filePath;
		var craftItem: CraftItem = load(fullPath);
		if (
			craftItem.materials[Ore.EOreType.Ore2] > 0 ||
			craftItem.materials[Ore.EOreType.Ore3] > 0
		):
			continue;
		self.AddCraftItem(craftItem);
