extends Node2D

@export var spawn_scene: PackedScene
@onready var spawn_zone: Node2D = $SpawnZone
@onready var col: CollisionShape2D = $SpawnZone/SpawnShape

var _timer: Timer

func _ready() -> void:
	randomize()

	_timer = Timer.new()
	_timer.wait_time = randi_range(0.4,2)
	_timer.autostart = true
	_timer.one_shot = false
	_timer.timeout.connect(_spawn_one)
	add_child(_timer)

func _spawn_one() -> void:
	if spawn_scene == null:
		push_error("Assign spawn_scene in the Inspector.")
		return

	var p_local_to_zone: Vector2 = random_point_inside_area_local_to_zone()

	var inst := spawn_scene.instantiate()
	spawn_zone.add_child(inst)

	if inst is Node2D:
		(inst as Node2D).position = p_local_to_zone  # local to SpawnZone

func random_point_inside_area_local_to_zone() -> Vector2:
	var rect: RectangleShape2D = col.shape as RectangleShape2D
	if rect == null:
		push_error("SpawnShape must use RectangleShape2D.")
		return Vector2.ZERO

	var ext: Vector2 = rect.extents

	# random point in CollisionShape2D local space
	var p_shape_local := Vector2(
		randf_range(-ext.x, ext.x),
		randf_range(-ext.y, ext.y)
	)

	# convert to global, then to SpawnZone local
	var p_global := col.to_global(p_shape_local)
	return spawn_zone.to_local(p_global)
