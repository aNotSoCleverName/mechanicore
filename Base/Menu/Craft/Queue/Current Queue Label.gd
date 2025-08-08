extends Label

func _ready():
	SignalBus_Base.update_craft_queue.connect(
		func (inCurrentQueueCount):
			self.text = str(inCurrentQueueCount)
	)
