extends Node

func GetNodeWindowPos(inNode: CanvasItem) -> Vector2:
	var viewport: Viewport = inNode.get_viewport();
	var subViewportContainer: SubViewportContainer = viewport.get_parent();
	var camera: Camera2D = viewport.get_camera_2d();
	
	var pos: Vector2 = inNode.get_global_transform().origin;
	
	if (camera != null && camera.get_canvas_layer_node() == inNode.get_canvas_layer_node()):
		var cameraTopLeft = camera.position;
		if (camera.anchor_mode == Camera2D.AnchorMode.ANCHOR_MODE_DRAG_CENTER):
			cameraTopLeft -= 0.5 * subViewportContainer.size;
		
		pos -= cameraTopLeft;
		pos -= camera.offset;
	
	while (subViewportContainer != null):
		pos += subViewportContainer.global_position;
		viewport = subViewportContainer.get_viewport();
		subViewportContainer = viewport.get_parent();
	
	var rootNode: Node = get_tree().current_scene;
	if (rootNode.has_method("get_position")):
		pos -= rootNode.position;
	
	return pos;
