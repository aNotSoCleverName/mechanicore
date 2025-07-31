extends Panel

@export var craftItem: CraftItem;

func _ready() -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/Icon.texture = self.craftItem.image;
	
	$MarginContainer/HBoxContainer/Details/Price/Label.text = str(self.craftItem.price);
	$MarginContainer/HBoxContainer/Details/Time/Label.text = str(self.craftItem.timeSec).pad_decimals(1) + "s"
	
	for oreType: Ore.EOreType in self.craftItem.materials.keys():
		var matNode: HBoxContainer = $MarginContainer/HBoxContainer/Details/Materials.find_child("Ore" + str(oreType));
		
		if (self.craftItem.materials[oreType] == 0):
			matNode.queue_free();
			continue;
		
		var label: Label = matNode.get_child(1);
		label.text = str(self.craftItem.materials[oreType]);
