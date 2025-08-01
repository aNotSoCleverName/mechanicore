extends VBoxContainer
class_name Base

# Key = craftItem, value = amount
static var craftItems: Dictionary = { };

func _on_tree_entered() -> void:
	SignalBus_Base.craft_finished.connect(
		func (inCraftItem: CraftItem):
			Base.craftItems[inCraftItem] += 1;
	);

func _ready() -> void:
	# Initiate craftItems
	for craftItemNode: CraftItemNode in $"Menu/Craft/Craft Items".get_children() as Array[CraftItemNode]:
		Base.craftItems[craftItemNode.craftItem] = 0;
