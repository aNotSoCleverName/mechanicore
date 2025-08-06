extends HBoxContainer
class_name Order;

var alienBody: Sprite2D;

func _ready() -> void:
	self.visible = false;
	
	var timer: Timer = $Timer;
	timer.timeout.connect(
		func ():
			SignalBus_Base.shop_leave_angry.emit();
			SignalBus_Base.shop_customer_leave.emit();
	)
	SignalBus_Base.shop_customer_leave.connect(
		func ():
			timer.stop();
	)
	
	SignalBus_Base.shop_make_order.connect(
		func (inAlien: Alien):
			self.alienBody = inAlien.get_child(0);
			
			self.visible = true;
			$Bubble/Item.texture = inAlien.orderedItem.image;
			timer.start(inAlien.waitTime);
	)
	
	SignalBus_Base.shop_queue_empty.connect(
		func ():
			self.visible = false;
	)
