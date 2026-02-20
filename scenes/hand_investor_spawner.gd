extends Node2D

@export var hand_investor_scene: PackedScene
@export var respawn_delay: float = randf_range(1,5)

var _timer: Timer

func _ready() -> void:
	randomize()

	_timer = Timer.new()
	_timer.wait_time = respawn_delay
	_timer.one_shot = true
	add_child(_timer)

	_spawn_one()

func _spawn_one() -> void:
	if hand_investor_scene == null:
		push_error("Assign hand_investor_scene in Inspector.")
		return

	var inst := hand_investor_scene.instantiate()
	add_child(inst)

	# When it despawns, wait a bit, then spawn again
	inst.tree_exited.connect(func():
		_timer.start()
	)
	_timer.timeout.connect(func():
		_spawn_one()
	, CONNECT_ONE_SHOT)
