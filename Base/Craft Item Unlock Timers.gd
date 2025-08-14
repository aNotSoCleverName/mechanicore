extends Node2D

### This script determines which CraftItem can be crafted/ordered
### At first, only items that can be crafted with just Ore1 to be crafted/ordered
### This is to prevent Ore that has not yet been obtained to be needed
### For example, we don't want aliens to order items that require Ore2 when the player just started the game

### Items with Ore2 can only be crafted/ordered after:
### 1. Player has obtained Ore2
### OR
### 2. Enough time has passed in the game (see the const in this script). This way, player is encouraged to go deeper
### Same thing applies to Ore3

@onready var _ore2Timer: Timer = $"Ore2 Timer";
const ORE2_FORCE_UNLOCK_TIME_SEC: float = 15 * 60;
var _isOre2Unlocked: bool = false;

@onready var _ore3Timer: Timer = $"Ore3 Timer";
const ORE3_FORCE_UNLOCK_TIME_SEC: float = 30 * 60;
var _isOre3Unlocked: bool = false;

@onready var _base: Base = self.find_parent("Base");
func _AddCraftItemsToDict(inUnlockedOreType: Ore.EOreType):
	var rarerOreTypes: Array[Ore.EOreType] = [];
	for oreType: Ore.EOreType in Ore.EOreType.values():
		if (oreType > inUnlockedOreType):
			rarerOreTypes.append(oreType);
	
	for filePath: String in DirAccess.open(self._base.CRAFT_ITEM_RESOURCES_DIR).get_files():
		filePath = filePath.split(".remap")[0];
		if !(filePath.ends_with(".tres")):
			continue;
		
		var craftItem: CraftItem = load(self._base.CRAFT_ITEM_RESOURCES_DIR + filePath);
		
		if (self._base.craftItems.has(craftItem)):
			continue;
		
		# If craft item requires rarer ore types than the one that is unlocked, don't unlock the craft item
		var isRequireRarerOreType: bool = false;
		for rarerOreType: Ore.EOreType in rarerOreTypes:
			if (craftItem.materials[rarerOreType] > 0):
				isRequireRarerOreType = true;
				break;
		if (isRequireRarerOreType):
			continue;
		
		self._base.AddCraftItem(craftItem);

func _ready():
	self._ore2Timer.wait_time = self.ORE2_FORCE_UNLOCK_TIME_SEC;
	self._ore2Timer.timeout.connect(
		func ():
			self._ore2Timer.stop();
			
			if (self._isOre2Unlocked):
				return;
			self._isOre2Unlocked = true;
			
			self._AddCraftItemsToDict(Ore.EOreType.Ore2);
	)
	self._ore2Timer.start();
	
	self._ore3Timer.wait_time = self.ORE3_FORCE_UNLOCK_TIME_SEC;
	self._ore3Timer.timeout.connect(
		func ():
			self._ore3Timer.stop();
			
			if (self._isOre3Unlocked):
				return;
			self._isOre3Unlocked = true;
			
			self._AddCraftItemsToDict(Ore.EOreType.Ore3);
	)
	self._ore3Timer.start();
	
	# Unlock craft items if when docking, the new ore type is transferred to base
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, inDrill: Drill):
			if (!inIsDocked):
				return;
			
			if (
				inDrill.inventory[Ore.EOreType.Ore2] > 0 &&
				!self._isOre2Unlocked
			):
				self._isOre2Unlocked = true;
				self._AddCraftItemsToDict(Ore.EOreType.Ore2);
			
			if (
				inDrill.inventory[Ore.EOreType.Ore3] > 0 &&
				!self._isOre3Unlocked
			):
				self._isOre3Unlocked = true;
				self._AddCraftItemsToDict(Ore.EOreType.Ore3);
	)
