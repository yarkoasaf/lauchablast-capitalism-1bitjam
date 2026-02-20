# Obstacle.gd
extends Area2D

@export var speed: float = 300.0
@export var despawn_x: float = -50.0     # when off-screen, delete
@export var fade_in_time: float = 0.1    # seconds
@export var lifetime: float = 5.0        # total seconds alive
@export var fade_out_time: float = 0.2   # seconds (fade before despawn)

#load textures
@onready var sprite: Sprite2D = $Sprite2D
const WOL_TEX: Texture2D = preload("res://assets/sprites/da wol.png")
const REC_TEX: Texture2D = preload("res://assets/sprites/da rect.png")
const PET_TEX: Texture2D = preload("res://assets/sprites/output-onlinepngtools.png")

var _dying: bool = false

func _ready() -> void:
	#sprite random selector
	load_texture()
	# Fade in
	modulate.a = 0.0
	var t_in: Tween = create_tween()
	t_in.tween_property(self, "modulate:a", 1.0, fade_in_time) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

	# Schedule fade-out so it finishes at `lifetime`
	var start_fade_at: float = maxf(0.0, lifetime - fade_out_time)
	get_tree().create_timer(start_fade_at).timeout.connect(_begin_despawn)

func _process(delta: float) -> void:
	position.x -= speed * delta
	if global_position.x < despawn_x:
		_begin_despawn()

func _begin_despawn() -> void:
	if _dying:
		return
	_dying = true

	# Optional: stop collisions while fading out
	monitoring = false
	monitorable = false

	var t_out: Tween = create_tween()
	t_out.tween_property(self, "modulate:a", 0.0, fade_out_time) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	t_out.finished.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Hit player!")
		if body.has_method("die"):
			body.die()

func load_texture():
	var choice = randi_range(1,3)
	match choice:
		1:
			sprite.texture = WOL_TEX
		2:
			sprite.texture = REC_TEX
		3: 
			sprite.texture = PET_TEX
