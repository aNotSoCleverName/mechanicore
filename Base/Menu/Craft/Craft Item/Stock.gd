extends Label

var _base: Base:
	get:
		if (_base == null):
			_base = self.find_parent("Base");
		return _base;
		
var _craftItemNode: CraftItemNode;

func _ready():
	var ancestorNode: Node = self.get_parent();
	while !(ancestorNode is CraftItemNode):
		ancestorNode = ancestorNode.get_parent();
	self._craftItemNode = ancestorNode;
	
	SignalBus_Base.craft_finished.connect(
		func (inCraftItem: CraftItem):
			if (inCraftItem == self._craftItemNode.craftItem):
				self.text = str(self._base.craftItems[inCraftItem]);
	)
	
	SignalBus_Base.shop_sell.connect(
		func (inCraftItem: CraftItem):
			if (inCraftItem == self._craftItemNode.craftItem):
				self.text = str(self._base.craftItems[inCraftItem]);
	)
