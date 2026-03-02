extends Node2D

@export var spawn_scene: PackedScene
@export var spawn_enabled := true
@export var min_wait := 1.0
@export var max_wait := 4.0

@onready var spawn_zone: Node2D = $SpawnZone
@onready var col: CollisionShape2D = $SpawnZone/SpawnShape

var _timer: Timer
var _spawn_tick := 0


func _ready() -> void:
	randomize()

	if spawn_scene == null:
		push_error("Spawner: assign spawn_scene in Inspector.")
		return
	if col == null or col.shape == null:
		push_error("Spawner: missing SpawnZone/SpawnShape.")
		return
	if min_wait <= 0.0 or max_wait < min_wait:
		push_error("Spawner: invalid wait range.")
		return

	_timer = Timer.new()
	_timer.one_shot = true # one shot so we can randomize each cycle
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)


	if spawn_enabled:
		_schedule_next()
	else:
		print("[Spawner] starts disabled")


func start_spawning(immediate := false) -> void:
	spawn_enabled = true
	if immediate:
		_spawn_one()
	_schedule_next()


func stop_spawning() -> void:
	spawn_enabled = false
	if _timer:
		_timer.stop()


func _schedule_next() -> void:
	if not spawn_enabled:
		return

	if _timer == null:
		return

	_timer.stop()

	var next_wait: float = randf_range(min_wait, max_wait)
	_timer.wait_time = next_wait
	_timer.start()


func _on_timer_timeout() -> void:
	_spawn_tick += 1

	if not spawn_enabled:
		return

	_spawn_one()       # always spawn, no matter what already exists
	_schedule_next()   # keep repeating


func _spawn_one() -> void:
	var p_global := random_point_inside_area_global()

	var inst := spawn_scene.instantiate()

	var container := get_parent()
	if container == null:
		container = self
	container.add_child(inst)

	if inst is Node2D:
		(inst as Node2D).global_position = p_global
	else:
		print("[Spawner] spawned root is not Node2D (position not set)")


func random_point_inside_area_global() -> Vector2:
	var shape: Shape2D = col.shape
	if not (shape is RectangleShape2D):
		push_error("Spawner: SpawnShape must be RectangleShape2D.")
		return spawn_zone.global_position

	var rect: RectangleShape2D = shape as RectangleShape2D
	var ext: Vector2 = rect.extents

	var p_shape_local := Vector2(
		randf_range(-ext.x, ext.x),
		randf_range(-ext.y, ext.y)
	)

	var p_global := col.to_global(p_shape_local)
	return p_global
