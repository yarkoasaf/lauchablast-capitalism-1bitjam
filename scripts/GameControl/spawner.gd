extends Node2D

signal spawn_enabled_changed(enabled: bool)

@export var spawn_scene: PackedScene
@export var spawn_enabled := true : set = set_spawn_enabled
@export var randomize_interval_each_tick := true
@export var min_wait := 0.4
@export var max_wait := 2.0

@onready var spawn_zone: Node2D = $SpawnZone
@onready var col: CollisionShape2D = $SpawnZone/SpawnShape

var _timer: Timer


func _ready() -> void:
	randomize()

	# Guards (keep these)
	if spawn_scene == null:
		push_error("Spawner: spawn_scene is NULL. Assign it in the Inspector.")
		return
	if spawn_zone == null:
		push_error("Spawner: SpawnZone not found. Check $SpawnZone path.")
		return
	if col == null:
		push_error("Spawner: SpawnZone/SpawnShape not found. Check node path.")
		return
	if col.shape == null:
		push_error("Spawner: SpawnShape has no Shape2D assigned in the inspector.")
		return
	if min_wait <= 0.0 or max_wait < min_wait:
		push_error("Spawner: Invalid wait range (min_wait must be > 0 and max_wait >= min_wait).")
		return

	_timer = Timer.new()
	_timer.one_shot = false
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)

	set_spawn_enabled(spawn_enabled)


# --- Public API ---

func start_spawning() -> void:
	set_spawn_enabled(true)

func stop_spawning() -> void:
	set_spawn_enabled(false)

func toggle_spawning() -> void:
	set_spawn_enabled(not spawn_enabled)


# --- Property setter ---

func set_spawn_enabled(value: bool) -> void:
	spawn_enabled = value

	if _timer == null:
		return

	if spawn_enabled:
		_set_next_wait_time()
		_timer.start()
	else:
		_timer.stop()

	spawn_enabled_changed.emit(spawn_enabled)


# --- Timer callback ---

func _on_timer_timeout() -> void:
	if not spawn_enabled:
		return

	_spawn_one()

	if randomize_interval_each_tick:
		_set_next_wait_time()
		_timer.start()


func _set_next_wait_time() -> void:
	_timer.wait_time = randf_range(min_wait, max_wait)


# --- Spawn logic (fixed placement) ---

func _spawn_one() -> void:
	var p_global: Vector2 = random_point_inside_area_global()

	var inst := spawn_scene.instantiate()

	# Put obstacles somewhere stable (not under SpawnZone)
	var container := get_parent()
	if container == null:
		container = self
	container.add_child(inst)

	if inst is Node2D:
		(inst as Node2D).global_position = p_global


func random_point_inside_area_global() -> Vector2:
	var shape: Shape2D = col.shape
	if not (shape is RectangleShape2D):
		push_error("Spawner: SpawnShape must use RectangleShape2D. Current: %s" % shape.get_class())
		return spawn_zone.global_position

	var rect: RectangleShape2D = shape as RectangleShape2D
	var ext: Vector2 = rect.extents

	var p_shape_local: Vector2 = Vector2(
		randf_range(-ext.x, ext.x),
		randf_range(-ext.y, ext.y)
	)

	return col.to_global(p_shape_local)
