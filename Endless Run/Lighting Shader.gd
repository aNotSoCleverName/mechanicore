extends ColorRect

const SHADER_KEY_VIEWPORT_SIZE: String = "viewportSize";
const SHADER_KEY_SURFACE_Y: String = "surfaceY";
const SHADER_KEY_SCROLL_OFFSET: String = "scrollOffset";
const SHADER_KEY_DRILL_POS_RELATIVE_TO_SCROLLED_VIEWPORT: String = "drillPosRelativeToScrolledViewport";

@onready var _viewportSize: Vector2 = self.get_viewport_rect().size;
@onready var _shader: ShaderMaterial = self.material;

func _ready():
	self.size = self._viewportSize;
	self.position = Vector2.ZERO;
	
	self._shader.set_shader_parameter(
		self.SHADER_KEY_VIEWPORT_SIZE,
		self._viewportSize
	)
	self._shader.set_shader_parameter(
		self.SHADER_KEY_SURFACE_Y,
		GlobalProperty_EndlessRun.SURFACE_Y
	);
	
	#SignalBus_EndlessRun.drill_change_pos.connect(
		#func (inPos: Vector2, _inDrill: Drill):
			#var scrollOffset: float = camera.global_position.y + camera.offset.y - viewportSize.y/2
			#
			#shader.set_shader_parameter(
				#self.SHADER_KEY_SCROLL_OFFSET,
				#scrollOffset
			#);
			#
			#shader.set_shader_parameter(
				#self.SHADER_KEY_DRILL_POS_RELATIVE_TO_SCROLLED_VIEWPORT,
				#Vector2(
					#inPos.x,
					#inPos.y - scrollOffset
				#)
			#)
	#)

@onready var _drill: Drill = GlobalProperty_EndlessRun.GetDrillNode(self);

@onready var _camera: Camera2D = self.get_viewport().get_camera_2d();

func _process(_delta):
	var scrollOffset: float = self._camera.global_position.y + self._camera.offset.y - self._viewportSize.y/2
	
	self._shader.set_shader_parameter(
		self.SHADER_KEY_SCROLL_OFFSET,
		scrollOffset
	);
	
	self._shader.set_shader_parameter(
		self.SHADER_KEY_DRILL_POS_RELATIVE_TO_SCROLLED_VIEWPORT,
		Vector2(
			self._drill.position.x,
			self._drill.position.y - scrollOffset
		)
	)
