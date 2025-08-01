extends HBoxContainer

func _on_tree_entered() -> void:
	SignalBus_Base.craft_queue.connect(
		func (inCraftItem: CraftItem):
			var newQueuedItem: CraftItemQueued = preload("res://Base/Menu/Craft/Queue/Craft Item Queued.tscn").instantiate();
			newQueuedItem._craftItem = inCraftItem;
			
			self.add_child(newQueuedItem);
	)

var _queueTop: CraftItemQueued;
func _on_child_order_changed():
	if (self.get_child_count() == 0):
		return;
	
	var queuedItem: CraftItemQueued = self.get_child(0);
	if (self._queueTop == queuedItem):
		return;
	
	self._queueTop = queuedItem;
	queuedItem.StartCraft();
