extends HBoxContainer
class_name Order;

func _ready() -> void:
	self.visible = false;
	
	var timer: Timer = $Timer;
	timer.timeout.connect(
		func ():
			SignalBus_Base.shop_leave_angry.emit();
			SignalBus_Base.shop_customer_leave.emit();
			SoundList.get_node("Decline").play();
	)
	SignalBus_Base.shop_customer_leave.connect(
		func ():
			timer.stop();
	)
	
	SignalBus_Base.shop_make_order.connect(
		func (inAlien: Alien):
			self.visible = true;
			
			$Bubble/Item.texture = inAlien.orderedItem.image;
			timer.start(inAlien.waitTime);
	)
	
	SignalBus_Base.shop_queue_empty.connect(
		func ():
			self.visible = false;
	)
	
	SignalBus_Base.shop_make_order.connect(
		self._ShowTutorial
	)

func _ShowTutorial(_inFirstInQueue: Alien):
	SignalBus_Base.shop_make_order.disconnect(
		self._ShowTutorial
	)
	
	SignalBus_Tutorial.show_tutorial.emit(
		self,
		"We've got our first customer! We can sell our items to earn money. Be careful, the customer won't wait forever!"
	)
	
	await SignalBus_Tutorial.hide_tutorial;
	
	var reputation: HBoxContainer = self.get_parent().find_child("Reputation");
	SignalBus_Tutorial.show_tutorial.emit(
		reputation,
		"This is our reputation bar. When we sell our item, we gain reputation." +
		"\n\nIf we keep our customer waiting too long, they'll get angry and bring our reputation down! If we decline them instead, we'll lose less reputation." +
		"\n\nOnce reputation reaches 0, no one would come to our shop, so we need to pay attention!"
	)
