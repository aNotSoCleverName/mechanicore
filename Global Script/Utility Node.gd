extends Node

func GetNodeWindowPos(inNode: CanvasItem) -> Vector2:
	var posInViewport: Vector2 = inNode.get_global_transform().origin;
	var viewport: Viewport = inNode.get_viewport();
	return (
		posInViewport +
		viewport.get_screen_transform().get_origin()
	)
