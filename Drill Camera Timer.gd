extends Timer

var _dockedYOffset: float = GlobalProperty_EndlessRun.VIEWPORT_SIZE.y/2 - GlobalProperty_EndlessRun.SURFACE_Y;
var _undockedYOffset: float = self._dockedYOffset + GlobalProperty_EndlessRun.SURFACE_Y/2;

func _on_tree_entered():
	var camera: Camera2D = self.get_parent();
	
	self.timeout.connect(
		func ():
			var newOffsetY = lerp(
				self._dockedYOffset,
				self._undockedYOffset,
				(camera.offset.y - self._dockedYOffset + 2)/(self._undockedYOffset - self._dockedYOffset)
			);
			camera.offset.y = clampf(newOffsetY, self._dockedYOffset, self._undockedYOffset);
			
			if (camera.offset.y == self._undockedYOffset):
				self.stop();
	)
	
	SignalBus_EndlessRun.drill_change_dock.connect(
		func (inIsDocked: bool, _inDrill: Drill):
			if (!inIsDocked):
				self.start();
			else:
				camera.offset.y = self._dockedYOffset;
				self.stop();
	)
