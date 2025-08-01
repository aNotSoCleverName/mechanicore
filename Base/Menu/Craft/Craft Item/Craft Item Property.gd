@tool
extends HBoxContainer

@export var icon: Texture2D:
	set(inValue):
		icon = inValue;
		
		if (self._textureRect != null):
			self._textureRect.texture = icon;

@export var text: String:
	set(inValue):
		text = str(inValue);
		
		if (self._label != null):
			self._label.text = text;

@onready var _textureRect: TextureRect = $TextureRect;
@onready var _label: Label = $Label;

func _ready() -> void:
	self._textureRect.texture = icon;
	self._label.text = text;
