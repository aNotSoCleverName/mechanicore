extends PanelContainer
class_name DrillUpgradeNode

@export var drillUpgrade: DrillUpgrade;

@onready var nameLabel: Label = $MarginContainer/HBoxContainer/VBoxContainer/Name;

@onready var levelLabel: Label = $MarginContainer/HBoxContainer/VBoxContainer/Details/Level/Label;

@onready var priceLabel: Label = $MarginContainer/HBoxContainer/VBoxContainer/Details/Price/Price;
var price: int = 0;
@onready var moneyLabel: Label = $MarginContainer/HBoxContainer/VBoxContainer/Details/Price/Money;

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
		self.drillUpgrade.prices.size() == self.drillUpgrade.maxLevel,
		"drillUpgrade.prices size must be equal to max level"
	);
	
	self.nameLabel.text = self.drillUpgrade.name;
	self.price = self.drillUpgrade.prices[0];
	self.priceLabel.text = str(self.price);
	
	SignalBus_Base.update_inventory_money.connect(
		func (inMoney: int):
			self._UpdateAffordablityUi(inMoney >= self.price);
			self.moneyLabel.text = str(inMoney);
	)

func _on_upgrade_button_pressed():
	var currentPrice: int = self.price;
	
	self.drillUpgrade.level += 1;
	self.levelLabel.text = str(self.drillUpgrade.level);
	
	#TODO: Call upgrade function
	
	if (self.drillUpgrade.level >= self.drillUpgrade.maxLevel):
		self.priceLabel.visible = false;
		self.upgradeButton.get_parent().visible = false;
	else:
		self.price = self.drillUpgrade.prices[self.drillUpgrade.level];
		self.priceLabel.text = str(self.price);
	
	SignalBus_Base.upgrade_drill.emit(currentPrice);
