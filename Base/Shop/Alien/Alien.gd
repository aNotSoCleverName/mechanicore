extends Node2D
class_name Alien;

static var _alienBodySpriteManager: AlienBodySpriteManager;

static var _base: Base;
static var _isMindReaderUnlocked: bool = false;

var bubbleNode: Sprite2D;

var orderedItem: CraftItem: 
	get:
		return orderedItem;
	set(inValue):
		orderedItem = inValue;
		$Bubble/Item.texture = orderedItem.image;
var waitTime: float;

func _on_tree_entered():
	if (Alien._alienBodySpriteManager == null):
		var queue: ShopQueue = self.get_parent();
		for childNode: Node in queue.get_children():
			if (childNode is AlienBodySpriteManager):
				Alien._alienBodySpriteManager = childNode;
				break;
	
	if (Alien._base == null):
		Alien._base = self.find_parent("Base");
	
	self.orderedItem = Alien._base.craftItems.keys()[randi_range(0, Alien._base.craftItems.size() - 1)];
	$Body.self_modulate = Color.WHITE;	# If waited too long, body modulates to red (handled by other script). Return it to normal color here
	
	var bodySprite: Texture2D = self._alienBodySpriteManager.bodySprites[randi_range(0, self._alienBodySpriteManager.bodySprites.size() - 1)];
	$Body.texture = bodySprite;
	self.waitTime = self._alienBodySpriteManager.waitTimeBasedOnBodySprite[bodySprite.resource_path];
	
	SignalBus_Base.upgrade_base_mind_reader_unlocked.connect(
		func ():
			Alien._isMindReaderUnlocked = true;
	)
	
	self.bubbleNode = $Bubble;
	self.bubbleNode.visible = Alien._isMindReaderUnlocked;
	SignalBus_Base.shop_make_order.connect(
		func (inAlien: Alien):
			if (inAlien == self):
				self.bubbleNode.visible = false;
	)
