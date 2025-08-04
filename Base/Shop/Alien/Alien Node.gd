extends Node2D
class_name AlienNode;

const DIR_PATH_ALIEN_RESOURCE: String = "res://Base/Shop/Alien/Alien Resource/";
static var aliens: Array[Alien] = [];

const DIR_PATH_CLOTHES_SPRITE: String = "res://Base/Shop/Alien/Sprite/Clothes/";
static var clothesSprites: Array[Texture2D] = [];

const DIR_PATH_CRAFT_ITEM_RESOURCE: String = "res://Base/Menu/Craft/Craft Item/Resources/";
static var craftItems: Array[CraftItem] = [];

var alien: Alien;
var orderedItem: CraftItem;

static func _InitArray(inArray: Array, inDirPath: String, inExtension: String):
	if (inArray.size() > 0):	# If already initialized
		return;
	
	var dir: DirAccess = DirAccess.open(inDirPath);
	for fileName: String in dir.get_files():
		if (!fileName.ends_with(inExtension)):
			continue;
		var resource = load(inDirPath + fileName);
		inArray.append(resource);

func _ready() -> void:
	AlienNode._InitArray(AlienNode.aliens, AlienNode.DIR_PATH_ALIEN_RESOURCE, ".tres");
	AlienNode._InitArray(AlienNode.clothesSprites, AlienNode.DIR_PATH_CLOTHES_SPRITE, ".png");
	AlienNode._InitArray(AlienNode.craftItems, AlienNode.DIR_PATH_CRAFT_ITEM_RESOURCE, ".tres");
	
	# Randomize alien
	self.alien = AlienNode.aliens[randi_range(0, AlienNode.aliens.size() - 1)];
	$Alien.texture = self.alien.bodySprite;
	
	# Randomize clothes
	$Alien/Clothes.texture = AlienNode.clothesSprites[randi_range(0, AlienNode.clothesSprites.size() - 1)];
	
	# Determine ordered item
	self.orderedItem = AlienNode.craftItems[randi_range(0, AlienNode.craftItems.size() - 1)];
