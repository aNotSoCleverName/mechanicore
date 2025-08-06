extends Node2D
class_name AlienNode;

# Key = Body sprite path, value = wait time
static var aliens: Dictionary = {
	"res://Base/Shop/Alien/Sprite/Body/Body1.png": 10,
	"res://Base/Shop/Alien/Sprite/Body/Body2.png": 12,
	"res://Base/Shop/Alien/Sprite/Body/Body3.png": 7,
	"res://Base/Shop/Alien/Sprite/Body/Body4.png": 8,
	"res://Base/Shop/Alien/Sprite/Body/Body5.png": 11,
	"res://Base/Shop/Alien/Sprite/Body/Body6.png": 9,
	"res://Base/Shop/Alien/Sprite/Body/Body7.png": 10,
	"res://Base/Shop/Alien/Sprite/Body/Body8.png": 3,
	"res://Base/Shop/Alien/Sprite/Body/Body9.png": 2,
};
static var bodySprites: Array[Texture2D] = [];

const DIR_PATH_CLOTHES_SPRITE: String = "res://Base/Shop/Alien/Sprite/Clothes/";
static var clothesSprites: Array[Texture2D] = [];

const DIR_PATH_CRAFT_ITEM_RESOURCE: String = "res://Base/Menu/Craft/Craft Item/Resources/";
static var craftItems: Array[CraftItem] = [];

var waitTime: float;
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

func _on_tree_entered():
	AlienNode._InitArray(AlienNode.clothesSprites, AlienNode.DIR_PATH_CLOTHES_SPRITE, ".png");
	AlienNode._InitArray(AlienNode.craftItems, AlienNode.DIR_PATH_CRAFT_ITEM_RESOURCE, ".tres");
	
	if (AlienNode.bodySprites.size() == 0):
		AlienNode.aliens.keys().map(
			func (inBodySpritePath: String):
				AlienNode.bodySprites.append(load(inBodySpritePath) as Texture2D);
		)
	
	var bodySprite: Texture2D = AlienNode.bodySprites[randi_range(0, AlienNode.bodySprites.size() - 1)];
	$Alien.texture = bodySprite;
	self.waitTime = self.aliens[bodySprite.resource_path];
	
	$Alien/Clothes.texture = AlienNode.clothesSprites[randi_range(0, AlienNode.clothesSprites.size() - 1)];
	self.orderedItem = AlienNode.craftItems[randi_range(0, AlienNode.craftItems.size() - 1)];
