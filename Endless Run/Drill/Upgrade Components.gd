extends Node2D
class_name UpgradeComponentContainer

var _drill: Drill;

#region Stats
enum EStatsKeys
{
	maxArmor,
}
var _stats: Dictionary = {
	EStatsKeys.maxArmor: 0,
}
func _updateStats(inKey: EStatsKeys, inValue: float):
	self._stats[inKey] = inValue;
	
	match (inKey):
		EStatsKeys.maxArmor:
			if (self._drill._isDocked):
				self._drill.armor = int(inValue);
#endregion

func _ready():
	self._drill = self.get_parent();
	
	SignalBus_Base.upgrade_drill.connect(
		func (_inPrice: int, inStatsKey: EStatsKeys, inStatsChange: float):
			self._updateStats(inStatsKey, self._stats[inStatsKey] + inStatsChange);
	)
