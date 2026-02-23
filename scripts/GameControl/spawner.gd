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

	_timer = Timer.new()
	_timer.one_shot = false
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)

	# apply initial state
	set_spawn_enabled(spawn_enabled)


# --- Public API (call these from other nodes or signals) ---

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

	# If you want a new random interval every spawn tick:
	if randomize_interval_each_tick:
		_set_next_wait_time()
		_timer.start()


func _set_next_wait_time() -> void:
	_timer.wait_time = randf_range(min_wait, max_wait)


# --- Spawn logic ---

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
