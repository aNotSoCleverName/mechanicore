extends Node

#func GetNodeScreenPos(inNode: CanvasItem) -> Vector2:
	#var subviewport: SubViewport = inNode.get_viewport();
	#subviewport.global_canvas_transform

func IsNodeFullyVisibleOnScreen(inNode: CanvasItem):
	return (
		#inNode.global_position;
		inNode.get_global_transform_with_canvas()
	)
