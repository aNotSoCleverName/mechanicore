extends Sprite2D

static var _clothesSprites: Array[Texture2D] = [];

func _on_tree_entered():
	UtilityInit.InitArrayFromFiles(self._clothesSprites, "res://Base/Shop/Alien/Sprite/Clothes/", ".png", true, false);
	self.texture = self._clothesSprites[randi_range(0, self._clothesSprites.size() - 1)];
