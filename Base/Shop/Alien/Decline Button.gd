extends Button

func _on_pressed():
	SignalBus_Base.shop_decline.emit();
