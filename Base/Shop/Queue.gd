extends Node2D
class_name ShopQueue;

const MAX_QUEUE: int = 1;

var _alienPool: Array[AlienNode] = [];
var alienQueues: Array[AlienNode] = [];

@onready var _spawnTimer: Timer = $Timer;

func _ResetSpawnTimer() -> void:
	#self._spawnTimer.wait_time = randi_range(5, 15);
	self._spawnTimer.wait_time = 1;

func _ExitQueue() -> void:
	self.alienQueues.remove_at(0);
	
	var firstInQueue: AlienNode = self.get_child(1); # Index 0 is timer
	self.remove_child(firstInQueue);
	self._alienPool.append(firstInQueue);
	
	if (self.alienQueues.size() == 0):
		SignalBus_Base.shop_queue_empty.emit();

func _ready() -> void:
	self._ResetSpawnTimer();
	self._spawnTimer.timeout.connect(
		func ():
			self._ResetSpawnTimer();
			
			var alienNode: AlienNode = self._alienPool.pop_back();
			if (alienNode == null):
				alienNode = preload("res://Base/Shop/Alien/Alien Node.tscn").instantiate();
			self.alienQueues.append(alienNode);
			self.add_child(alienNode);
	)
	self._spawnTimer.start();
	
	SignalBus_Base.shop_customer_leave.connect(
		func ():
			self._ExitQueue();
	)

func _on_child_entered_tree(_node):
	if (self.alienQueues.size() >= ShopQueue.MAX_QUEUE):
		self._spawnTimer.stop();

func _on_child_exiting_tree(_node):
	# Only start timer again if queue was full because it means the timer was stopped
	if (self.alienQueues.size() + 1 >= ShopQueue.MAX_QUEUE):
		self._ResetSpawnTimer();
		self._spawnTimer.start();

func _on_child_order_changed():
	if (!self.is_inside_tree()):
		return;
	
	if (self.alienQueues.size() > 0):
		SignalBus_Base.shop_make_order.emit(self.alienQueues[0]);
