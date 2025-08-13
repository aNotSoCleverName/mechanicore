extends VBoxContainer

@onready var _onscreenTimer: Timer = $"Onscreen Timer";
@onready var _fadeTimer: Timer = $"Fade Timer";

@onready var _gainedAmountLabel: Label = $"Gained Amount";
@onready var _lostAmountLabel: Label = $"Lost Amount";

var _opacity: float = 1:
	get:
		return _opacity;
	set(inValue):
		_opacity = inValue;
		self._gainedAmountLabel.self_modulate.a = _opacity;
		
		if (abs(int(self._lostAmountLabel.text)) > 0):
			self._lostAmountLabel.self_modulate.a = _opacity;
		else:
			self._lostAmountLabel.self_modulate.a = 0;

var _lostAmount: int = 0;

func _ready():
	self._opacity = 0;
	
	var ancestorNode: Node = self.get_parent();
	while !(ancestorNode is OreInventory):
		ancestorNode = ancestorNode.get_parent();
	var oreInventory: OreInventory = ancestorNode;
	
	SignalBus_EndlessRun.drill_explode.connect(
		func (inLostInventory: Dictionary):
			self._lostAmount = inLostInventory[oreInventory.oreType];
	);
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, inDrill: Drill):
			if (!inIsDocked):
				self._lostAmount = 0;
				return;
			
			self._gainedAmountLabel.text = "+" + str(inDrill.inventory[oreInventory.oreType]);
			self._lostAmountLabel.text = str(-self._lostAmount);
			
			self._opacity = 1;
			self._onscreenTimer.start();
	)
	
	self._onscreenTimer.timeout.connect(
		func ():
			self._onscreenTimer.stop();
			self._fadeTimer.start();
	);
	
	self._fadeTimer.timeout.connect(
		func ():
			if (self._opacity <= 0):
				self._fadeTimer.stop();
				return;
			
			self._opacity -= 0.05;
	)
