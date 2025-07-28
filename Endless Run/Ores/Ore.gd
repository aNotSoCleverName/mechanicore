extends Area2D
class_name Ore;

enum EOreType
{
	Ore1 = 1,
	Ore2 = 2,
	Ore3 = 3,
}

@export var oreType: EOreType = EOreType.Ore1;
@onready var icon: Texture2D = load(
	self.scene_file_path.get_base_dir() +
	"/Ore" + str(self.oreType) + ".png"
):
	get:
		return icon;

func _ready() -> void:
	$Sprite2D.texture = self.icon;

func _on_body_entered(_body):
	if (!(_body is Drill)):
		return;
	SignalBus_EndlessRun.ore_pick.emit(self);
