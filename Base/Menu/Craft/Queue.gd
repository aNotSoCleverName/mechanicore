extends HBoxContainer

func _on_tree_entered() -> void:
	SignalBus_Base.craft_queue.connect(
		func (inCraftItem: CraftItem):
			var newQueuedItem: CraftItemQueued = preload("res://Base/Menu/Craft/Queue/Craft Item Queued.tscn").instantiate();
			newQueuedItem._craftItem = inCraftItem;
			
			self.add_child(newQueuedItem);
			var firstQueuedItem: CraftItemQueued = self.get_child(0);
			if (firstQueuedItem == newQueuedItem):
				newQueuedItem.StartCraft();
	)
	
	SignalBus_Base.craft_finished.connect(
		func (_inCraftItem: CraftItem):
			if (self.get_child_count() > 0):
				var queuedItem: CraftItemQueued = self.get_child(0);
				queuedItem.StartCraft();
	)
