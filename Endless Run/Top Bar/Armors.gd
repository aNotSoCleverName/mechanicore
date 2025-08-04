extends HBoxContainer

var _armorPool: Array[TextureRect] = [];

func _ready():
	SignalBus_EndlessRun.update_drill_armor.connect(
		func (inDrill: Drill):
			while (self.get_child_count() < inDrill.armor):
				var armor: TextureRect = self._armorPool.pop_back();
				if (armor == null):
					armor = TextureRect.new();
					armor.texture = preload("res://Base/Menu/Drill/Drill Upgrade Node/Armor.png");
					armor.expand_mode = TextureRect.EXPAND_FIT_WIDTH;
				
				self.add_child(armor);
			
			if (inDrill.armor < 0):
				return;
			while (self.get_child_count() > inDrill.armor):
				var armor: TextureRect = self.get_child(0);
				self.remove_child(armor);
				self._armorPool.append(armor)
	)
