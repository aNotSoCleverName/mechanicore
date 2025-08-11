extends Node

var hasStartedDigging: bool;
var hasChangedDirection: bool;
var hasDocked: bool;
var hasCrafted: bool;
var hasMadeOrder: bool;
var isShowReputation: bool;

@warning_ignore("unused_signal")
signal show_tutorial(inNode: Node, inText: String, inDelaySec: float);
@warning_ignore("unused_signal")
signal hide_tutorial();
