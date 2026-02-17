# add_money_button.gd
extends Button

@export var amount: int = 1  # cuánto suma por click

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	global.gain_money(amount)
	
