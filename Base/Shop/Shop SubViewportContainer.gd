extends SubViewportContainer

func _ready():
	if (Main.IS_SKIP_TUTORIAL):
		await get_tree().process_frame;
		self._AddShop(null);
	else:
		SignalBus_Base.craft_finished.connect(
			self._AddShop
		);

func _AddShop(_inCraftItem: CraftItem):
	if (SignalBus_Base.craft_finished.is_connected(self._AddShop)):
		SignalBus_Base.craft_finished.disconnect(
			self._AddShop
		)
	
	var shop: Node = preload("res://Base/Shop/Shop.tscn").instantiate();
	self.add_child(shop);
	
	if (!Main.IS_SKIP_TUTORIAL):
		SignalBus_Tutorial.show_tutorial.emit(
			self,
			"This is our shop. There will be customers coming here to buy items that we have crafted."
		)
