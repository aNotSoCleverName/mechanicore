extends VBoxContainer
class_name Base

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

# Key = craftItem, value = amount
var craftItems: Dictionary = { };

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
			self._takeOres(inCraftItem.materials);
	);
	
	SignalBus_Base.craft_finished.connect(
		func (inCraftItem: CraftItem):
			self.craftItems[inCraftItem] += 1;
	);
	
	SignalBus_Base.craft_cancel.connect(
		func (inCraftItem: CraftItem):
			self._addOres(inCraftItem.materials);
	);
	
	SignalBus_Base.shop_sell.connect(
		func (inCraftItem: CraftItem):
			self.craftItems[inCraftItem] -= 1;
			self.money += inCraftItem.price;
	)
	
	SignalBus_Base.upgrade_drill.connect(
		func (inPrice: int, _inStatsKey: UpgradeComponentContainer.EStatsKeys, _inStatsChange: float):
			self.money -= inPrice;
	)

func _ready() -> void:
	# Initiate ores
	for oreType: Ore.EOreType in Ore.EOreType.values():
		self.ores[oreType] = 0;
	SignalBus_Base.update_ore_inventory.emit(self.ores);	# This triggers the code that checks if craft item text should be red/white depending on stock
	
	# Initiate craftItems
	for craftItemNode: CraftItemNode in $"Menu/Craft/Craft Items MarginContainer/ScrollContainer/MarginContainer/Craft Items".get_children() as Array[CraftItemNode]:
		self.craftItems[craftItemNode.craftItem] = 0;
