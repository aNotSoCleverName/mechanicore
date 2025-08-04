extends Label

func _on_tree_entered():
	SignalBus_Base.update_inventory_money.connect(
		func (inMoney: int):
			self.text = str(inMoney);
	);
