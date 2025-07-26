extends Line2D

const MAX_POINT_COUNT: int = 20;

var _drill: Drill;

func _ready() -> void:
	self._drill = self.get_parent().find_child("Drill");
	
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (inPos: Vector2):
			var drillHeadOffset: Vector2 = Vector2(60, 0).rotated(self._drill.rotation);
			self.add_point(inPos + drillHeadOffset);
			
			if (self.points.size() > self.MAX_POINT_COUNT):
				self.remove_point(0);
	)
