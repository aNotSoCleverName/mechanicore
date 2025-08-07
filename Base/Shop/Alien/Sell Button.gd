extends Button

@onready var _base: Base = self.find_parent("Base");
var _orderedItem: CraftItem;

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
		func (_inAlien: Alien, inOrderedItem: CraftItem):
			self._orderedItem = inOrderedItem;
			self._Disable(self._base.craftItems[self._orderedItem] == 0);
	)
	
	SignalBus_Base.craft_finished.connect(
		func (inCraftItem: CraftItem) -> void:
			if (inCraftItem == self._orderedItem):
				self._Disable(false);
	)

func _on_pressed():
	SignalBus_Base.shop_sell.emit(self._orderedItem);
	SignalBus_Base.shop_customer_leave.emit();
