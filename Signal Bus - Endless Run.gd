extends Node

enum EDrillDirection
{
	LEFT = 20,		# deg
	RIGHT = -20,	# deg
}
signal drill_change_dir(inDir: EDrillDirection);
