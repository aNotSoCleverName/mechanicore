extends Button

func _on_pressed():
	SignalBus_Base.shop_decline.emit();
	SignalBus_Base.shop_customer_leave.emit();
	$SFX.play();
