extends HBoxContainer

@export var oreType: Ore.EOreType = Ore.EOreType.Ore1;
var amount: int = 0:
	get:
		return amount;
	set(inValue):
		amount = inValue;
		$Amount.text = str(amount);

func _ready() -> void:
	var iconNode: TextureRect = self.find_child("Icon");
	iconNode.texture = Ore.GetOreTexture(self.oreType);

func _on_tree_entered():
	SignalBus_EndlessRun.ore_pick.connect(
		func (inOre: Ore):
			if (inOre.oreType == self.oreType):
				amount += 1;
	)
