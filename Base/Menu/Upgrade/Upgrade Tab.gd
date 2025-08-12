extends VBoxContainer

@export var upgradeTarget: Upgrade.EUpgradeTarget;
@onready var _upgradeContainer: VBoxContainer = $MarginContainer/ScrollContainer/MarginContainer/Upgrades;

func _ready():
	var upgrades: Array[Upgrade] = [];
	
	match self.upgradeTarget:
		Upgrade.EUpgradeTarget.drill:
			UtilityInit.InitArrayFromFiles(upgrades, "res://Base/Menu/Upgrade/Resource/Drill/", ".tres", true, false);
		Upgrade.EUpgradeTarget.base:
			UtilityInit.InitArrayFromFiles(upgrades, "res://Base/Menu/Upgrade/Resource/Base/", ".tres", true, false);
		_:
			assert(
				false,
				"Upgrade target unhandled"
			);
	
	for upgrade: Upgrade in upgrades:
		var upgradeNode: UpgradeNode = preload("res://Base/Menu/Upgrade/Upgrade Node/Upgrade Node.tscn").instantiate();
		upgradeNode.upgrade = upgrade;
		self._upgradeContainer.add_child(upgradeNode);
