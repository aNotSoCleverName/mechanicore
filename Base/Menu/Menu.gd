extends TabContainer

func _ready():
	SignalBus_Tutorial.add_craft_tab.connect(
		self._AddCraftTab
	)

func _AddCraftTab():
	SignalBus_Tutorial.add_craft_tab.disconnect(
		self._AddCraftTab
	)
	
	var craftTab: Node = preload("res://Base/Menu/Craft/Craft Tab.tscn").instantiate();
	self.add_child(craftTab);
	
	SignalBus_Tutorial.show_tutorial.emit(
		self,
		"In the [i]base[/i], you can craft items using the ores you've collected. Different items require different ores and different amount of time to be crafted.",
	)
