extends HBoxContainer

const DEFAULT_REPUTATION = 20;

var _reputation: int:
	get:
		return _reputation;
	set(inValue):
		_reputation = inValue;
		$ProgressBar.value = _reputation;
		$ProgressBar/Label.text = str(_reputation);

func _on_tree_entered():
	SignalBus_Base.shop_sell.connect(
		func (_inCraftItem: CraftItem):
			self._reputation += 2;
	)
	
	SignalBus_Base.shop_decline.connect(
		func ():
			self._reputation -= 2;
	)
	
	SignalBus_Base.shop_leave_angry.connect(
		func ():
			self._reputation -= 5;
	)

func _ready():
	self._reputation = self.DEFAULT_REPUTATION;
