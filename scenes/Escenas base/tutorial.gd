extends Node2D

@export var target_presses := 30
var a_press_count := 0

@onready var a_count_label: Label = $ACountLabel 

func _enter_tree() -> void:
	$pantalla/HandInvestorSpawner.auto_start = false
	$pantalla/HandInvestorSpawner.spawn_enabled = false

func _ready() -> void:
	# stop spawner (change Node2D to the actual spawner node name if needed)
	$pantalla/Node2D.stop_spawning()

	_update_a_counter_text()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("wave"):
		_on_a_pressed()

func _on_a_pressed() -> void:
	if a_press_count < target_presses:
		a_press_count += 1
		_update_a_counter_text()

	else:
		
		a_count_label.text = "Great!\nNow try this\n when marks Buy go down (buy low)\nwhen marks Sell go up (sell high)"

func _update_a_counter_text() -> void:
	if a_count_label:
		a_count_label.text = "Move by pressing the letter of screen [ A ]\n%d / %d" % [a_press_count, target_presses]

	
