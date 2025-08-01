extends Label

func _on_tree_entered():
	self.self_modulate.a = 0;
	
	var ancestorNode: Node = self.get_parent();
	while !(ancestorNode is OreInventory):
		ancestorNode = ancestorNode.get_parent();
	var oreInventory: OreInventory = ancestorNode;
	
	SignalBus_EndlessRun.drill_explode.connect(
		func (inLostInventory: Dictionary):
			self.text = str(-inLostInventory[oreInventory.oreType]);
			self.self_modulate.a = 1;
			
			$"Onscreen Timer".start();
	);
	
	$"Onscreen Timer".timeout.connect(
		func ():
			$"Onscreen Timer".stop();
			$"Fade Timer".start();
	);
	
	$"Fade Timer".timeout.connect(
		func ():
			if (self.self_modulate.a <= 0):
				$"Fade Timer".stop();
				return;
			
			self.self_modulate.a -= 0.1;
	)
