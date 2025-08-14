extends TabContainer

func _ready():
	self.self_modulate = Color.BLACK;
	SignalBus_Tutorial.add_craft_tab.connect(
		self._AddCraftTab
	)
	
	SignalBus_Base.shop_sell.connect(
		self._AddUpgradeTabs
	)

func _AddCraftTab():
	SignalBus_Tutorial.add_craft_tab.disconnect(
		self._AddCraftTab
	)
	self.self_modulate = Color.WHITE;
	
	var craftTab: Node = preload("res://Base/Menu/Craft/Craft Tab.tscn").instantiate();
	self.add_child(craftTab);
	
	SignalBus_Tutorial.show_tutorial.emit(
		self,
		"In the [i]base[/i], we can craft items using the ores we've collected. Different items require different ores and different amount of time to be crafted.",
	)

func _AddUpgradeTabs(_inOrderedItem: CraftItem):
	SignalBus_Base.shop_sell.disconnect(
		self._AddUpgradeTabs
	)
	
	var upgradeTabResource: Resource = preload("res://Base/Menu/Upgrade/Upgrade Tab.tscn");
	var drillUpgradesTab: UpgradeTab = upgradeTabResource.instantiate();
	drillUpgradesTab.name = "Drill Upgrades";
	drillUpgradesTab.upgradeTarget = Upgrade.EUpgradeTarget.drill;
	self.add_child(drillUpgradesTab);
	
	var baseUpgradesTab: UpgradeTab = upgradeTabResource.instantiate();
	baseUpgradesTab.name = "Base Upgrades";
	baseUpgradesTab.upgradeTarget = Upgrade.EUpgradeTarget.base;
	self.add_child(baseUpgradesTab);
	
	self.current_tab = self.get_tab_idx_from_control(drillUpgradesTab);
	
	SignalBus_Tutorial.show_tutorial.emit(
		self,
		"Using the money we earned, we can buy upgrades for the drill and the base to increase our efficiency.",
	)
