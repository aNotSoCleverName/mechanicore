extends ColorRect
class_name OrePlaceholder

@export var oreType: Ore.EOreType = Ore.EOreType.Ore1;

func _ready() -> void:
	SignalBus_EndlessRun.ore_place.emit(self);

func _on_child_exiting_tree(node):
	if (!(node is Ore)):
		return;
	self.queue_free();
