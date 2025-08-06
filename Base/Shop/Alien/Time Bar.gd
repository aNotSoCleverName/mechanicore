extends ProgressBar

var _orderTimer: Timer;
@onready var _tickTimer: Timer = $"Tick Timer";

func _ready() -> void:
	var ancestorNode: Node = self.get_parent();
	while !(ancestorNode is Order):
		ancestorNode = ancestorNode.get_parent();
	var order: Order = ancestorNode;
	self._orderTimer = order.get_node("Timer");
	
	self._tickTimer.timeout.connect(
		func ():
			self.value = self._orderTimer.time_left / self._orderTimer.wait_time;
			$Label.text = str(self._orderTimer.time_left).pad_decimals(1) + "s";
	)
	
	SignalBus_Base.shop_make_order.connect(
		func (_inAlien: Alien):
			self._tickTimer.start();
	)
