extends HBoxContainer
class_name OreInventory;

@export var oreType: Ore.EOreType = Ore.EOreType.Ore1;
var _drill: Drill;

func _on_tree_entered():
	SignalBus_EndlessRun.ore_pick.connect(
		func (inOre: Ore):
			if (inOre.oreType != self.oreType):
				return;
			$Amount.text = str(self._drill.inventory[inOre.oreType]);
	)
	
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, _inDrill: Drill):
			if (!inIsDocked):
				return;
			$Amount.text = "0";
	)

func _ready() -> void:
	var iconNode: TextureRect = self.find_child("Icon");
	iconNode.texture = Ore.GetOreTexture(self.oreType);
	
	self._drill = GlobalProperty_EndlessRun.GetDrillNode(self);
