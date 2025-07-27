extends Line2D

const MIN_DIST_BETWEEN_POINTS: int = 20;
const MAX_DIST: int = 200;

var _drill: Drill;

var _shaderTexture: Texture2D;

func _ready() -> void:
	self._drill = self.find_parent("Endless Run").find_child("Drill");
	
	var shaderMaterial: ShaderMaterial = self.material;
	self._shaderTexture = shaderMaterial.get_shader_parameter("image_texture");
	
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool):
			if (!inIsDocked):
				return;
			
			self.clear_points();
	)
	
	SignalBus_EndlessRun.drill_change_pos.connect(
		func (inPos: Vector2):
			shaderMaterial.set_shader_parameter("drill_pos", inPos);
			
			var drillHeadPos: Vector2 = self._GetDrillHeadPos(inPos);
			
			if (self.points.size() == 0):
				var drillTailPos: Vector2 = self._GetDrillTailPos(inPos);
				self.add_point(drillTailPos);
				self.add_point(inPos);
				self.add_point(drillHeadPos);
				return;
			
			var prevPoint: Vector2 = self.points[self.points.size() - 1];
			if (prevPoint.distance_to(drillHeadPos) < self.MIN_DIST_BETWEEN_POINTS):
				return;
			self.add_point(drillHeadPos);
			
			var oldestPoint: Vector2 = self.points[0];
			if (oldestPoint.distance_to(drillHeadPos) > self.MAX_DIST):
				self.remove_point(0);
	)

var drillHeadAndTailOffset: int = 60;
func _GetDrillHeadPos(inDrillCenterPos: Vector2):
	var drillHeadOffset: Vector2 = Vector2(self.drillHeadAndTailOffset, 0).rotated(self._drill.rotation);
	return inDrillCenterPos + drillHeadOffset;
func _GetDrillTailPos(inDrillCenterPos: Vector2):
	var drillTailOffset: Vector2 = Vector2(-self.drillHeadAndTailOffset, 0).rotated(self._drill.rotation);
	return inDrillCenterPos + drillTailOffset;
