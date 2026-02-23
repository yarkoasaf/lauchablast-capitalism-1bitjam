extends Node2D

@export var hand_investor_scene: PackedScene

@export var spawn_enabled := true
@export var auto_start := true
@export var min_respawn_delay := 1.0
@export var max_respawn_delay := 5.0

var _timer: Timer
var _current_inst: Node = null

func _ready() -> void:
	randomize()

	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout) # connect ONCE
	add_child(_timer)

	print("[Spawner] _ready | spawn_enabled=", spawn_enabled, " auto_start=", auto_start)

	if auto_start and spawn_enabled:
		_spawn_one()
	else:
		print("[Spawner] No spawn at start (auto_start/spawn_enabled prevented it)")

func start_spawning() -> void:
	spawn_enabled = true
	print("[Spawner] start_spawning()")
	# spawn now if nothing exists
	if _current_inst == null or not is_instance_valid(_current_inst):
		_spawn_one()

func stop_spawning(despawn_current := false) -> void:
	spawn_enabled = false
	_timer.stop()
	print("[Spawner] stop_spawning() | timer stopped")

	if despawn_current and _current_inst != null and is_instance_valid(_current_inst):
		print("[Spawner] despawning current instance")
		_current_inst.queue_free()
		_current_inst = null

func toggle_spawning() -> void:
	if spawn_enabled:
		stop_spawning()
	else:
		start_spawning()

func _spawn_one() -> void:
	if not spawn_enabled:
		print("[Spawner] _spawn_one blocked (spawn_enabled=false)")
		return

	if hand_investor_scene == null:
		push_error("Assign hand_investor_scene in Inspector.")
		return

	if _current_inst != null and is_instance_valid(_current_inst):
		print("[Spawner] _spawn_one blocked (instance already exists)")
		return

	print("[Spawner] Spawning now")
	var inst := hand_investor_scene.instantiate()
	_current_inst = inst
	add_child(inst)

	# When it exits, schedule respawn (only if enabled)
	inst.tree_exited.connect(_on_inst_exited, CONNECT_ONE_SHOT)

func _on_inst_exited() -> void:
	print("[Spawner] instance exited")
	_current_inst = null

	if not spawn_enabled:
		print("[Spawner] respawn NOT scheduled (spawn_enabled=false)")
		return

	var delay := randf_range(min_respawn_delay, max_respawn_delay)
	_timer.stop()
	_timer.wait_time = delay
	_timer.start()
	print("[Spawner] respawn scheduled in ", delay, "s")

func _on_timer_timeout() -> void:
	print("[Spawner] timer timeout")
	_spawn_one()
