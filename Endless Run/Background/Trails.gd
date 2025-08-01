extends Line2D

const MIN_DIST_BETWEEN_POINTS: int = 20;
const MAX_DIST: int = 350;

var _drill: Drill;

var _shaderTexture: Texture2D;

func _ready() -> void:
	self._drill = GlobalProperty_EndlessRun.GetDrillNode(self);
	
	var shaderMaterial: ShaderMaterial = self.material;
	self._shaderTexture = shaderMaterial.get_shader_parameter("image_texture");
	
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, _inDrill: Drill):
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
			if (prevPoint.distance_to(drillHeadPos) > self.MIN_DIST_BETWEEN_POINTS):
				self.add_point(drillHeadPos);
			
			var oldestPoint: Vector2 = self.points[0];
			if (oldestPoint.distance_to(drillHeadPos) > self.MAX_DIST):
				self.remove_point(0);
	)

var drillHeadAndTailOffset: int = 100;	# How far head/tail are from drill's center
func _GetDrillHeadPos(inDrillCenterPos: Vector2):
	# Generate squiggle effect
	var squiggleOffset: float = 3;	# Offset drill head by X px to the sides
	var squiggleRandom: float = (randf() - 0.5) * 2 * squiggleOffset;	# Convert to random -offset to +offset
	
	var drillHeadOffset: Vector2 = Vector2(self.drillHeadAndTailOffset, squiggleRandom).rotated(self._drill.rotation);
	return inDrillCenterPos + drillHeadOffset;
func _GetDrillTailPos(inDrillCenterPos: Vector2):
	var drillTailOffset: Vector2 = Vector2(-self.drillHeadAndTailOffset, 0).rotated(self._drill.rotation);
	return inDrillCenterPos + drillTailOffset;
