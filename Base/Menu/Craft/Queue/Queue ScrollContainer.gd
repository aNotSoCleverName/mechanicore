extends ScrollContainer

func _ready():
	var hScrollBarHeight = self.get_h_scroll_bar().size.y;
	var marginContainer: MarginContainer = self.get_child(0);
	self.custom_minimum_size += Vector2(
		0,
		hScrollBarHeight + marginContainer.get_theme_constant("margin_top") + marginContainer.get_theme_constant("margin_bottom")
	);
