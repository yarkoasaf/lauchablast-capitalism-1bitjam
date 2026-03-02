extends Node2D


# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("beach") and global.money >= 100000:
		get_tree().change_scene_to_file("res://scenes/Escenas base/End.tscn")
