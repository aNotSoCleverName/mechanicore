extends VBoxContainer
class_name Base

# Key = ore type, value = amount
static var ores: Dictionary = { };
static func _addOres(inOres: Dictionary):
	for oreType: Ore.EOreType in ores.keys():
		Base.ores[oreType] += inOres[oreType];
	SignalBus_Base.update_ore_inventory.emit(ores);
static func _takeOres(inOres: Dictionary):
	for oreType: Ore.EOreType in ores.keys():
		Base.ores[oreType] -= inOres[oreType];
	SignalBus_Base.update_ore_inventory.emit(ores);

# Key = craftItem, value = amount
static var craftItems: Dictionary = { };

static var money: int = 0;

func _on_tree_entered() -> void:
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, inDrill: Drill):
			if (!inIsDocked):
				return;
			
			Base._addOres(inDrill.inventory);
	)
	
	SignalBus_Base.craft_queue.connect(
		func (inCraftItem: CraftItem):
			Base._takeOres(inCraftItem.materials);
	);
	
	SignalBus_Base.craft_finished.connect(
		func (inCraftItem: CraftItem):
			Base.craftItems[inCraftItem] += 1;
	);
	
	SignalBus_Base.craft_cancel.connect(
		func (inCraftItem: CraftItem):
			Base._addOres(inCraftItem.materials);
	);
	
	SignalBus_Base.shop_sell.connect(
		func (inCraftItem: CraftItem):
			Base.craftItems[inCraftItem] -= 1;
			Base.money += inCraftItem.price;
			
			SignalBus_Base.update_inventory_money.emit(Base.money);
	)

func _ready() -> void:
	# Initiate ores
	for oreType: Ore.EOreType in Ore.EOreType.values():
		Base.ores[oreType] = 0;
	SignalBus_Base.update_ore_inventory.emit(Base.ores);	# This triggers the code that checks if craft item text should be red/white depending on stock
	
	# Initiate craftItems
	for craftItemNode: CraftItemNode in $"Menu/Craft/Craft Items MarginContainer/ScrollContainer/MarginContainer/Craft Items".get_children() as Array[CraftItemNode]:
		Base.craftItems[craftItemNode.craftItem] = 0;
