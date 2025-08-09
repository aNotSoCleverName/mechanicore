extends Node

@warning_ignore("unused_signal")
signal craft_queue(inCraftItem: CraftItem);
@warning_ignore("unused_signal")
signal craft_finished(inCraftItem: CraftItem);
@warning_ignore("unused_signal")
signal craft_cancel(inCraftItem: CraftItem);
@warning_ignore("unused_signal")
signal update_craft_queue(inCurrentQueueCount: int);

@warning_ignore("unused_signal")
signal update_inventory_ore(inCurrentInventory: Dictionary);
@warning_ignore("unused_signal")
signal update_inventory_money(inMoney: int);

@warning_ignore("unused_signal")
signal shop_make_order(inAlien: Alien);
@warning_ignore("unused_signal")
signal shop_customer_leave();
@warning_ignore("unused_signal")
signal shop_sell(inCraftItem: CraftItem);
@warning_ignore("unused_signal")
signal shop_decline();
@warning_ignore("unused_signal")
signal shop_leave_angry();
@warning_ignore("unused_signal")
signal shop_queue_empty();

@warning_ignore("unused_signal")
signal upgrade_drill(inPrice: int, inStatsKey: Upgrade.EStatsKeys, inStatsChange: float);
@warning_ignore("unused_signal")
signal upgrade_base(inPrice: int, inStatsKey: Upgrade.EStatsKeys, inStatsChange: float);

# Upgrade stat
@warning_ignore("unused_signal")
signal upgrade_base_mind_reader_unlocked();
@warning_ignore("unused_signal")
signal upgrade_base_shorten_craft_time();

@warning_ignore("unused_signal")
signal game_over();
