extends Node

@warning_ignore("unused_signal")
signal show_tutorial(inNode: Node, inText: String);
@warning_ignore("unused_signal")
signal hide_tutorial();

var hasStartedDigging: bool;
var hasChangedDirection: bool;
var hasPickedOre: bool;
var hasDocked: bool;

@warning_ignore("unused_signal")
signal add_craft_tab();

var hasCrafted: bool;
var hasMadeOrder: bool;
var isShowReputation: bool;
