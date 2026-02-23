# money_label.gd
extends Label

func _ready() -> void:
	global.money_changed.connect(_on_money_changed)
	_on_money_changed(global.money) # set inicial

func _on_money_changed(new_money: int) -> void:
	text = "money: " + str(new_money)
