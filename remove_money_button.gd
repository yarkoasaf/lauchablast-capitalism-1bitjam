# remove_money_button.gd
extends Button

@export var amount: int = 1

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	global.lose_money(amount)
	
