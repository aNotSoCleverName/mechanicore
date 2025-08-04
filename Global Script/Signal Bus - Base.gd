extends Node

@warning_ignore("unused_signal")
signal craft_queue(inCraftItem: CraftItem);
@warning_ignore("unused_signal")
signal craft_finished(inCraftItem: CraftItem);
@warning_ignore("unused_signal")
signal craft_cancel(inCraftItem: CraftItem);

@warning_ignore("unused_signal")
signal update_ore_inventory(inCurrentInventory: Dictionary);
@warning_ignore("unused_signal")
signal update_inventory_money(inMoney: int);

@warning_ignore("unused_signal")
signal shop_make_order(inAlienNode: AlienNode);
@warning_ignore("unused_signal")
signal shop_sell(inCraftItem: CraftItem);
@warning_ignore("unused_signal")
signal shop_decline();
@warning_ignore("unused_signal")
signal shop_leave_angry();
@warning_ignore("unused_signal")
signal shop_queue_empty();

@warning_ignore("unused_signal")
signal upgrade_drill(inPrice: int, inStatsKey: UpgradeComponentContainer.EStatsKeys, inStatsChange: float);

@warning_ignore("unused_signal")
signal game_over();
