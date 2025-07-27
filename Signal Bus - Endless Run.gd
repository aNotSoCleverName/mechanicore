extends Node

enum EDrillDirection
{
	LEFT = 110,		# deg
	RIGHT = 70,	# deg
}
signal drill_change_dir(inDir: EDrillDirection, inDrill: Drill);

signal drill_change_pos(inPos: Vector2, inDrill: Drill);

signal drill_change_dock(inIsDocked: bool, inDrill: Drill);
