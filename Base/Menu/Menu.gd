extends TabContainer

func _ready():
	if (Main.IS_SKIP_TUTORIAL):
		await get_tree().process_frame;
		self._AddCraftTab();
		self._AddUpgradeTabs(null);
	else:
		self.self_modulate = Color.BLACK;
		SignalBus_Tutorial.add_craft_tab.connect(
			self._AddCraftTab
		)
		
		SignalBus_Base.shop_sell.connect(
			self._AddUpgradeTabs
		)

func _AddCraftTab():
	if (SignalBus_Tutorial.add_craft_tab.is_connected(self._AddCraftTab)):
		SignalBus_Tutorial.add_craft_tab.disconnect(
			self._AddCraftTab
		)
	self.self_modulate = Color.WHITE;
	
	var craftTab: Node = preload("res://Base/Menu/Craft/Craft Tab.tscn").instantiate();
	self.add_child(craftTab);
	
	if (!Main.IS_SKIP_TUTORIAL):
		SignalBus_Tutorial.show_tutorial.emit(
			self,
			"In the [i]base[/i], we can craft items using the ores we've collected. Different items require different ores and different amount of time to be crafted.",
		)

func _AddUpgradeTabs(_inOrderedItem: CraftItem):
	if (SignalBus_Base.shop_sell.is_connected(self._AddUpgradeTabs)):
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
	
	if (!Main.IS_SKIP_TUTORIAL):
		SignalBus_Tutorial.show_tutorial.emit(
			self,
			"Using the money we earned, we can buy upgrades for the drill and the base to increase our efficiency.",
		)
