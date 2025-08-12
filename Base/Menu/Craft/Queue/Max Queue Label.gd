extends Label

@onready var _base: Base = self.find_parent("Base");

func _ready():
	self.text = str(self._base.DEFAULT_MAX_CRAFT_QUEUE);
	
	SignalBus_Base.upgrade_base.connect(
		func (_inPrice: int, inStatsKey: Upgrade.EStatsKeys, _inStatsChange: float):
			if (inStatsKey != Upgrade.EStatsKeys.base_MaxCraftQueue):
				return;
			
			self.text = str(
				self._base.DEFAULT_MAX_CRAFT_QUEUE +
				int(self._base.stats[inStatsKey])
			)
	)
