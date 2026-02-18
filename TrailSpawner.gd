# trail_spawner.gd
extends Node2D

@export var player_path: NodePath
@export var point_scene: PackedScene
@export var spawn_interval := 0.03  # seconds (smaller = denser trail)

@onready var player := get_node(player_path) as Node2D
var _t := 0.0

func _process(delta: float) -> void:
	_t += delta
	if _t >= spawn_interval:
		_t = 0.0
		var p := point_scene.instantiate() as Node2D
		get_parent().add_child(p)  # add to Main (world space)
		p.global_position = player.global_position
