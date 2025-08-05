extends HBoxContainer
class_name Order;

func _ready() -> void:
	self.visible = false;
	
	var timer: Timer = $Timer;
	timer.timeout.connect(
		func ():
			SignalBus_Base.shop_leave_angry.emit();
			SignalBus_Base.shop_customer_leave.emit();
			timer.stop();
	)
	
	SignalBus_Base.shop_make_order.connect(
		func (inAlienNode: AlienNode):
			self.visible = true;
			$Bubble/Item.texture = inAlienNode.orderedItem.image;
			timer.start(inAlienNode.alien.waitTimeSec);
	)
	
	SignalBus_Base.shop_queue_empty.connect(
		func ():
			self.visible = false;
	)
