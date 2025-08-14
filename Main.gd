extends PanelContainer

func _on_tree_entered():
	SignalBus_Base.game_over.connect(
		func ():
			var gameOver: Control = preload("res://Game Over.tscn").instantiate();
			self.add_child(gameOver);
	)
	
	preload("res://Endless Run/Ores/Ore Chunk/Ore Chunk1.tscn");
	preload("res://Endless Run/Ores/Ore Chunk/Ore Chunk2.tscn");
	preload("res://Endless Run/Ores/Ore Chunk/Ore Chunk3.tscn");
	preload("res://Endless Run/Ores/Ore Chunk/Ore Chunk4.tscn");
	preload("res://Endless Run/Ores/Ore Chunk/Ore Chunk5.tscn");
	preload("res://Endless Run/Ores/Ore Chunk/Ore Chunk6.tscn");
	preload("res://Endless Run/Ores/Ore1.png")
	preload("res://Endless Run/Ores/Ore2.png")
	preload("res://Endless Run/Ores/Ore3.png")
	
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item1.png")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item1.tres")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item2.png")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item2.tres")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item3.png")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item3.tres")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item4.png")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item4.tres")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item5.png")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item5.tres")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item6.png")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item6.tres")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item7.png")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item7.tres")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item8.png")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item8.tres")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item9.png")
	preload("res://Base/Menu/Craft/Craft Item/Resources/Item9.tres")
	
	preload("res://Base/Shop/Alien/Sprite/Body/Body1.png");
	preload("res://Base/Shop/Alien/Sprite/Body/Body2.png");
	preload("res://Base/Shop/Alien/Sprite/Body/Body3.png");
	preload("res://Base/Shop/Alien/Sprite/Body/Body4.png");
	preload("res://Base/Shop/Alien/Sprite/Body/Body5.png");
	preload("res://Base/Shop/Alien/Sprite/Body/Body6.png");
	preload("res://Base/Shop/Alien/Sprite/Body/Body7.png");
	preload("res://Base/Shop/Alien/Sprite/Body/Body8.png");
	preload("res://Base/Shop/Alien/Sprite/Body/Body9.png");
	
