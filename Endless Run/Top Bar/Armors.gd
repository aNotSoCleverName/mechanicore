extends HBoxContainer

var _shieldPool: Array[TextureRect] = [];

func _ready():
	SignalBus_EndlessRun.update_drill_shield.connect(
		func (inDrill: Drill):
			while (self.get_child_count() < inDrill.shield):
				var shield: TextureRect = self._shieldPool.pop_back();
				if (shield == null):
					shield = TextureRect.new();
					shield.texture = preload("res://Base/Menu/Drill/Drill Upgrade Node/Shield.png");
					shield.expand_mode = TextureRect.EXPAND_FIT_WIDTH;
				
				self.add_child(shield);
			
			if (inDrill.shield < 0):
				return;
			while (self.get_child_count() > inDrill.shield):
				var shield: TextureRect = self.get_child(0);
				self.remove_child(shield);
				self._shieldPool.append(shield)
	)
