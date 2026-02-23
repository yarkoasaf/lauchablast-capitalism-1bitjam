extends Node2D

@export var target_presses := 30
var a_press_count := 0
var tutorial_part: int = 0

@onready var a_count_label: Label = $ACountLabel
@onready var pantalla: Node = $pantalla

# One-time guards
var _part2_started := false
var _part2_timer_started := false


func _enter_tree() -> void:
	var p := get_node_or_null("pantalla")
	if p:
		var sp := p.get_node_or_null("HandInvestorSpawner")
		if sp:
			sp.auto_start = false
			sp.spawn_enabled = false


func _ready() -> void:
	var spawner_obs := pantalla.get_node_or_null("spawnerOBS")
	if spawner_obs:
		spawner_obs.stop_spawning()

	_update_text()


func _process(_delta: float) -> void:
	_update_text()


func _update_text() -> void:
	match tutorial_part:
		0:
			a_count_label.text = "Move by pressing the letter of screen [ A ]\n%d / %d" % [a_press_count, target_presses]

		1:
			var hand_spawner := pantalla.get_node_or_null("HandInvestorSpawner")
			if hand_spawner:
				hand_spawner.start_spawning()

			var buy := int(pantalla.get("buy_count"))
			var sell := int(pantalla.get("sell_count"))

			a_count_label.text = "Great!\nNow try this\nwhen marks Buy go down (buy low) %d/1\nwhen marks Sell go up (sell high) %d/1" % [buy, sell]

			if buy >= 1 and sell >= 1:
				tutorial_part = 2

		2:
			if not _part2_started:
				_part2_started = true

				var spawner_obs := pantalla.get_node_or_null("spawnerOBS")
				if spawner_obs:
					spawner_obs.start_spawning(true) # immediate + keep spawning

			a_count_label.text = "Nice!\nRemember to avoid obstacles or you will lose money"

			# Start the 10s transition timer only once
			if not _part2_timer_started:
				_part2_timer_started = true
				get_tree().create_timer(10.0).timeout.connect(_go_to_game, CONNECT_ONE_SHOT)


func _go_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/Escenas base/game.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("wave"):
		_on_a_pressed()


func _on_a_pressed() -> void:
	a_press_count += 1
	if a_press_count == target_presses:
		a_press_count += 1
		tutorial_part = 1
