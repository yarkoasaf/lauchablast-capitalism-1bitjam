# trail.gd
extends Line2D

@export var scroll_left_speed := 300.0  # pixels/sec
@export var BodyToFollow: Node2D

func _ready() -> void:
	set_point_position(0,BodyToFollow.position)

func _process(delta: float) -> void:
	 # Move existing points left
	for i in range(get_point_count()):
		set_point_position(i, get_point_position(i) + Vector2(-scroll_left_speed * delta, 0.0))
	
	# Add a new point at the BodyToFollow's position (converted to local)
	if BodyToFollow:
		add_point(to_local(BodyToFollow.global_position))
	
	# Remove points with x coordinate less than 0
	var i = 0
	while i < get_point_count():
		if (get_point_position(i)<position):
			remove_point(i)
		else:
			i += 1
