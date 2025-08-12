extends Node

func GetDrillNode(inThisNode: Node) -> Drill:
	return inThisNode.find_parent("Game").find_child("Drill");

const VIEWPORT_SIZE: Vector2 = Vector2(896, 720);
const SURFACE_Y: float = 256;
