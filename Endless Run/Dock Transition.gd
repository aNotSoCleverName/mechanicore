extends ColorRect
class_name DockTransition

const TRANSITION_DURATION_SEC: float = 0.5;
const DOCK_MID_TRANSITION_DELAY_SEC: float = TRANSITION_DURATION_SEC/2;	# Put drill back to base when screen is covered
var _transitionTween: Tween;

func _ready():
	var viewportSize: Vector2 = self.get_viewport_rect().size;
	self.size = Vector2(
		viewportSize.x,
		viewportSize.y*2
	);
	self.position = Vector2(0, viewportSize.y);
	
	SignalBus_EndlessRun.play_dock_transition_then_dock.connect(
		func (inDrill: Drill):
			inDrill.velocity = Vector2(0, 0);
			inDrill.isDockTransitionPlaying = true;
			
			self.position = Vector2(0, viewportSize.y);
			
			if (self._transitionTween != null):
				self._transitionTween.kill();
			self._transitionTween = self.create_tween();
			self._transitionTween.tween_property(
				self,
				^"position:y",
				-self.size.y,
				self.TRANSITION_DURATION_SEC
			)
			
			await self.get_tree().create_timer(self.DOCK_MID_TRANSITION_DELAY_SEC).timeout;
			await get_tree().process_frame;
			
			inDrill.isDockTransitionPlaying = false;
			inDrill._isDocked = true;
	);
