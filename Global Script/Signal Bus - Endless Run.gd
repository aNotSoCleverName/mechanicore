extends Node

enum EDrillDirection	# Value = degree
{
	DOCKED = 90,
	LEFT = 110,
	RIGHT = 70,
	
	DODGE_LEFT = 180,
	DODGE_RIGHT = 0,
}
@warning_ignore("unused_signal")
signal drill_change_dir(inDir: EDrillDirection, inDrill: Drill);
@warning_ignore("unused_signal")
signal drill_change_pos(inPos: Vector2, inDrill: Drill);
@warning_ignore("unused_signal")
signal drill_change_speed(inDrill: Drill);
@warning_ignore("unused_signal")
signal drill_change_dock(inIsDocked: bool, inDrill: Drill);

@warning_ignore("unused_signal")
signal drill_explode(inLostInventory: Dictionary);

@warning_ignore("unused_signal")
signal update_drill_shield(inDrill: Drill);

@warning_ignore("unused_signal")
signal ore_place(inOrePlaceHolder: OrePlaceholder);
@warning_ignore("unused_signal")
signal ore_pick(inOre: Ore);

@warning_ignore("unused_signal")
signal bomb_explode();
