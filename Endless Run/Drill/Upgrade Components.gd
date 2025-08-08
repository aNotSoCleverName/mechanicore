extends Node2D
class_name UpgradeComponentContainer

var _drill: Drill;

#region Stats
enum EStatsKeys
{
	maxShield,
	maxSpeed,
	doubleOreChance,
	dodge,
}
var _stats: Dictionary = {
	EStatsKeys.maxShield: 0,
	EStatsKeys.maxSpeed: 0,
	EStatsKeys.doubleOreChance: 0,
	EStatsKeys.dodge: 0,
}
func _updateStats(inKey: EStatsKeys, inValue: float):
	self._stats[inKey] = inValue;
	
	match (inKey):
		EStatsKeys.maxShield:
			if (self._drill._isDocked):
				self._drill.shield = int(inValue);
		EStatsKeys.dodge:
			var dodgeComponent: DodgeComponent = preload("res://Base/Menu/Upgrade/Resource/Drill/Dodge.tscn").instantiate();
			self.add_child(dodgeComponent);
#endregion

func _ready():
	self._drill = self.get_parent();
	
	SignalBus_Base.upgrade_drill.connect(
		func (_inPrice: int, inStatsKey: EStatsKeys, inStatsChange: float):
			self._updateStats(inStatsKey, self._stats[inStatsKey] + inStatsChange);
	)
