extends SubViewportContainer

func _ready():
	SignalBus_Base.craft_finished.connect(
		self._AddShop
	);

func _AddShop(_inCraftItem: CraftItem):
	SignalBus_Base.craft_finished.disconnect(
		self._AddShop
	)
	
	var shop: Node = preload("res://Base/Shop/Shop.tscn").instantiate();
	self.add_child(shop);
	
	SignalBus_Tutorial.show_tutorial.emit(
		self,
		"This is our shop. There will be customers coming here to buy items that we have crafted."
	)
