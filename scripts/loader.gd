extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func loadGame() -> void:
	get_tree().change_scene_to_file("res://scenes/Escenas base/game.tscn")
func loadMenu() -> void:
	get_tree().change_scene_to_file("res://scenes/Escenas base/Menu.tscn")
func loadEnd() -> void:
	get_tree().change_scene_to_file("res://scenes/Escenas base/End.tscn")


func _on_button_pressed() -> void:
	loadGame()
	pass # Replace with function body.
