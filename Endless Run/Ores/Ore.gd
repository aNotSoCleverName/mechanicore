extends Area2D
class_name Ore;

const oreDir: String = "res://Endless Run/Ores/";

enum EOreType
{
	Ore1 = 1,
	Ore2 = 2,
	Ore3 = 3,
}

@export var oreType: EOreType = EOreType.Ore1:
	get:
		return oreType;
	set(inValue):
		oreType = inValue;
		$Sprite2D.texture = Ore.GetOreTexture(self.oreType);

#region Public functions
static func GetOreTexture(inOreType: EOreType) -> Resource:
	return load(
		 Ore.oreDir +
		"Ore" + str(inOreType) + ".png"
	);
#endregion

#region Built-in functions
func _on_body_entered(_body):
	if (!(_body is Drill)):
		return;
	SignalBus_EndlessRun.ore_pick.emit(self);
#endregion
