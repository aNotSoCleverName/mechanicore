extends PanelContainer
class_name UpgradeNode

static var _drill: Drill;

@export var upgrade: Upgrade;

@onready var icon: TextureRect = $MarginContainer/HBoxContainer/Icon;
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
		self.upgrade != null,
		"upgrade must not be null"
	);
	assert(
		self.upgrade.statChange.size() == self.upgrade.maxLevel,
		"upgrade.statChange size must be equal to max level"
	);
	assert(
		self.upgrade.prices.size() == self.upgrade.maxLevel,
		"upgrade.prices size must be equal to max level"
	);
	
	if (UpgradeNode._drill == null):
		UpgradeNode._drill = get_tree().root.find_child("Drill", true);
	
	self.icon.texture = self.upgrade.icon;
	self.nameLabel.text = self.upgrade.name;
	self.price = self.upgrade.prices[0];
	self.priceLabel.text = str(self.price);
	self.maxLevelLabel.text = str(self.upgrade.maxLevel);
	
	SignalBus_Base.update_inventory_money.connect(
		func (inMoney: int):
			self._UpdateAffordablityUi(inMoney >= self.price);
			self.moneyLabel.text = str(inMoney);
	)

func _on_upgrade_button_pressed():
	var currentPrice: int = self.price;
	var currentLevel: int = self.upgrade.level;
	
	self.upgrade.level += 1;
	self.levelLabel.text = str(self.upgrade.level);
	
	if (self.upgrade.level >= self.upgrade.maxLevel):
		self.priceContainer.visible = false;
		self.upgradeButton.get_parent().visible = false;
	else:
		self.price = self.upgrade.prices[self.upgrade.level];
		self.priceLabel.text = str(self.price);
	
	SignalBus_Base.upgrade_drill.emit(currentPrice, self.upgrade.stats, self.upgrade.statChange[currentLevel]);
