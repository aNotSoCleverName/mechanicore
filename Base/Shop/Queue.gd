extends Node2D
class_name ShopQueue;

const MAX_QUEUE: int = 5;

@onready var _base: Base = self.find_parent("Base");

var _alienPool: Array[Alien] = [];
var alienQueues: Array[Alien] = [];
var firstInQueue: Alien;

@onready var _spawnTimer: Timer = $Timer;

func _ResetSpawnTimer() -> void:
	#self._spawnTimer.wait_time = randi_range(5, 15);
	self._spawnTimer.wait_time = 1;

func _ExitQueue() -> void:
	self.alienQueues.remove_at(0);
	self._alienPool.append(firstInQueue);
	self.remove_child(firstInQueue);
	
	if (self.alienQueues.size() == 0):
		SignalBus_Base.shop_queue_empty.emit();

func _ready() -> void:
	self._ResetSpawnTimer();
	self._spawnTimer.timeout.connect(
		func ():
			self._ResetSpawnTimer();
			
			var alien: Alien = self._alienPool.pop_back();
			if (alien == null):
				alien = preload("res://Base/Shop/Alien/Alien.tscn").instantiate();
			self.alienQueues.append(alien);
			self.add_child(alien);
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

const DISTANCE_BETWEEN_CUSTOMERS: float = 60;
func _on_child_order_changed():
	if (!self.is_inside_tree()):
		return;
	
	if (self.alienQueues.size() == 0):
		self.firstInQueue = null;
		return;
	
	if (self.firstInQueue != self.alienQueues[0]):
		self.firstInQueue = self.alienQueues[0];
		
		var orderedItem: CraftItem = self._base.craftItems.keys()[randi_range(0, self._base.craftItems.size() - 1)];
		SignalBus_Base.shop_make_order.emit(self.firstInQueue, orderedItem);
	
	for i: int in self.alienQueues.size():
		var alien: Alien = self.alienQueues[i];
		alien.position.x = 0 + self.DISTANCE_BETWEEN_CUSTOMERS * i;
