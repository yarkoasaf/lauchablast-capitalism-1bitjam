# trail.gd
extends Line2D

@export var scroll_left_speed := 300.0  # pixels/sec


func _process(delta: float) -> void:
	# Move existing points left
	for i in range(get_point_count()):
		set_point_position(i, get_point_position(i) + Vector2(-scroll_left_speed * delta, 0.0))

	# Add a new point at the player's position (converted to local)
	add_point(to_local(get_parent().global_position))
