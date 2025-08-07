extends ProgressBar

const MODULATE_THRESHOLD: float = 0.4;

var _orderTimer: Timer;
@onready var _tickTimer: Timer = $"Tick Timer";

var _alienBody: Sprite2D;

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
			
			if (self.value > self.MODULATE_THRESHOLD):
				return;
			else:
				var mood: float = lerpf(0.3, 1, self.value/self.MODULATE_THRESHOLD);
				self._alienBody.self_modulate = Color(1, mood, mood);
	)
	
	SignalBus_Base.shop_make_order.connect(
		func (inAlien: Alien, _inOrderedItem: CraftItem):
			self._alienBody = inAlien.find_child("Body");
			self._tickTimer.start();
	)
