extends Button

var _alienNode: AlienNode;

func _Disable(inIsDisabled: bool) -> void:
	self.disabled = inIsDisabled;
	if (self.disabled):
		self.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN;
		self.text = "Out of Stock";
	else:
		self.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;
		self.text = "Sell";

func _ready() -> void:
	SignalBus_Base.shop_make_order.connect(
		func (inAlienNode: AlienNode):
			self._alienNode = inAlienNode;
			
			self._Disable(Base.craftItems[self._alienNode.orderedItem] == 0);
			
	)
	
	SignalBus_Base.craft_finished.connect(
		func (inCraftItem: CraftItem) -> void:
			if (inCraftItem == self._alienNode.orderedItem):
				self._Disable(false);
	)

func _on_pressed():
	SignalBus_Base.shop_sell.emit(self._alienNode.orderedItem);
