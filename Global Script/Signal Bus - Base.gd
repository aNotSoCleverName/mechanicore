extends Node

@warning_ignore("unused_signal")
signal craft_queue(inCraftItem: CraftItem);
@warning_ignore("unused_signal")
signal craft_finished(inCraftItem: CraftItem);
@warning_ignore("unused_signal")
signal craft_cancel(inCraftItem: CraftItem);

@warning_ignore("unused_signal")
signal sell(inCraftItemId: int);
