extends Node2D
class_name UpgradeComponentContainer

var _drill: Drill;

#region Stats
var _stats: Dictionary = {
	Upgrade.EStatsKeys.drill_MaxShield: 0,
	Upgrade.EStatsKeys.drill_MaxSpeed: 0,
	Upgrade.EStatsKeys.drill_DoubleOreChance: 0,
	Upgrade.EStatsKeys.drill_Dodge: 0,
}
func _updateStats(inKey: Upgrade.EStatsKeys, inValue: float):
	self._stats[inKey] = inValue;
	
	match (inKey):
		Upgrade.EStatsKeys.drill_MaxShield:
			if (self._drill._isDocked):
				self._drill.shield = int(inValue);
		Upgrade.EStatsKeys.drill_Dodge:
			var dodgeComponent: DodgeComponent = preload("res://Base/Menu/Upgrade/Resource/Drill/Dodge.tscn").instantiate();
			self.add_child(dodgeComponent);
#endregion

func _ready():
	self._drill = self.get_parent();
	
	SignalBus_Base.upgrade_drill.connect(
		func (_inPrice: int, inStatsKey: Upgrade.EStatsKeys, inStatsChange: float):
			self._updateStats(inStatsKey, self._stats[inStatsKey] + inStatsChange);
	)
