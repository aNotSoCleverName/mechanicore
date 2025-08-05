extends PanelContainer
class_name DrillUpgradeNode

static var _drill: Drill;

@export var drillUpgrade: DrillUpgrade;

@onready var nameLabel: Label = $MarginContainer/HBoxContainer/VBoxContainer/Name;

@onready var levelContainer: HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/Details/Level;
@onready var levelLabel: Label = levelContainer.find_child("Level");
@onready var maxLevelLabel: Label = levelContainer.find_child("Max Level");

@onready var priceContainer: HBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/Details/Price;
@onready var priceLabel: Label = priceContainer.find_child("Price");
@onready var moneyLabel: Label = priceContainer.find_child("Money");
var price: int = 0;

@onready var upgradeButton: TextureButton = $"MarginContainer/HBoxContainer/Upgrade/Upgrade Button";

func _UpdateAffordablityUi(inCanAfford: bool) -> void:
	self.upgradeButton.disabled = !inCanAfford;
	if (inCanAfford):
		self.upgradeButton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;
		self.priceLabel.self_modulate = Color.WHITE;
	else:
		self.upgradeButton.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN;
		self.priceLabel.self_modulate = Color.RED;

func _ready():
	assert(
		self.drillUpgrade != null,
		"drillUpgrade must not be null"
	);
	assert(
		self.drillUpgrade.statChange.size() == self.drillUpgrade.maxLevel,
		"drillUpgrade.statChange size must be equal to max level"
	);
	assert(
		self.drillUpgrade.prices.size() == self.drillUpgrade.maxLevel,
		"drillUpgrade.prices size must be equal to max level"
	);
	
	if (DrillUpgradeNode._drill == null):
		DrillUpgradeNode._drill = get_tree().root.find_child("Drill", true);
	
	self.nameLabel.text = self.drillUpgrade.name;
	self.price = self.drillUpgrade.prices[0];
	self.priceLabel.text = str(self.price);
	self.maxLevelLabel.text = str(self.drillUpgrade.maxLevel);
	
	SignalBus_Base.update_inventory_money.connect(
		func (inMoney: int):
			self._UpdateAffordablityUi(inMoney >= self.price);
			self.moneyLabel.text = str(inMoney);
	)

func _on_upgrade_button_pressed():
	var currentPrice: int = self.price;
	var currentLevel: int = self.drillUpgrade.level;
	
	self.drillUpgrade.level += 1;
	self.levelLabel.text = str(self.drillUpgrade.level);
	
	if (self.drillUpgrade.level >= self.drillUpgrade.maxLevel):
		self.priceContainer.visible = false;
		self.upgradeButton.get_parent().visible = false;
	else:
		self.price = self.drillUpgrade.prices[self.drillUpgrade.level];
		self.priceLabel.text = str(self.price);
	
	SignalBus_Base.upgrade_drill.emit(currentPrice, self.drillUpgrade.stats, self.drillUpgrade.statChange[currentLevel]);
