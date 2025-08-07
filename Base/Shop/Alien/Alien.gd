extends Node2D
class_name Alien;

# Key = Body sprite path, value = wait time
static var waitTimeBasedOnBodySprite: Dictionary = {
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

var waitTime: float;

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
	Alien._InitArray(Alien.clothesSprites, Alien.DIR_PATH_CLOTHES_SPRITE, ".png");
	
	if (Alien.bodySprites.size() == 0):
		Alien.waitTimeBasedOnBodySprite.keys().map(
			func (inBodySpritePath: String):
				Alien.bodySprites.append(load(inBodySpritePath) as Texture2D);
		)
	
	var bodySprite: Texture2D = Alien.bodySprites[randi_range(0, Alien.bodySprites.size() - 1)];
	$Body.texture = bodySprite;
	$Body.self_modulate = Color.WHITE;
	self.waitTime = Alien.waitTimeBasedOnBodySprite[bodySprite.resource_path];
	
	$Body/Clothes.texture = Alien.clothesSprites[randi_range(0, Alien.clothesSprites.size() - 1)];
