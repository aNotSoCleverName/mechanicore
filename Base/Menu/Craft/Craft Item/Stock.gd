extends Label

var _base: Base = self.find_parent("Base");

func _on_tree_entered():
	SignalBus_Base.craft_finished.connect(
		func (inCraftItem: CraftItem):
			var ancestorNode: Node = self.get_parent();
			while !(ancestorNode is CraftItemNode):
				ancestorNode = ancestorNode.get_parent();
			var craftItemNode: CraftItemNode = ancestorNode;
			
			if (inCraftItem == craftItemNode.craftItem):
				self.text = str(self._base.craftItems[inCraftItem]);
	)
	
	SignalBus_Base.shop_sell.connect(
		func (inCraftItem: CraftItem):
			self.text = str(self._base.craftItems[inCraftItem]);
	)
