extends Panel
class_name CraftItemQueued

const SHADER_PARAM_PROGRESS: String = "progress";

@onready var _base: Base = self.find_parent("Base");
@onready var _timer: Timer = $Timer;

var _craftItem: CraftItem;

#region Public functions
func StartCraft() -> void:
	self._timer.start();
#endregion

#region Built-in functions
func _ready() -> void:
	self.material = self.material.duplicate();
	(self.material as ShaderMaterial).set_shader_parameter(self.SHADER_PARAM_PROGRESS, 0);
	
	self._timer.wait_time = self._craftItem.timeSec * (1 - self._base.stats[Upgrade.EStatsKeys.base_ShortenCraftTime]);
	self._timer.timeout.connect(
		func ():
			self._timer.stop();
			self.get_parent().remove_child(self);	# Even though queue_free() is called later, this is needed so queue manager can start the crafting the correct item
			SignalBus_Base.craft_finished.emit(self._craftItem);
			
			self.call_deferred("queue_free");
	);
	
	$"MarginContainer/HBoxContainer/TextureRect".texture = self._craftItem.image;
	
func _process(_delta):
	if (self._timer.is_stopped()):
		return;
	
	var shader: ShaderMaterial = self.material as ShaderMaterial;
	var progress: float = 1 - (self._timer.time_left / self._timer.wait_time);
	shader.set_shader_parameter(self.SHADER_PARAM_PROGRESS, progress);
#endregion

func _on_cancel_pressed():
	SignalBus_Base.craft_cancel.emit(self._craftItem);
	self.queue_free();
