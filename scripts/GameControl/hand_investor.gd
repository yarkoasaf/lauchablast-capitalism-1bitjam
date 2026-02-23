#hand_investor.gd
extends Node2D

@export var lifetime: float = randf_range(3,10)
@export var fade_out_time: float = 0.1
@export var update_rate: float = 0.05

@onready var sprite: Sprite2D = $Pivot/Hand
@onready var bar: ProgressBar = $Pivot/UI/Panel/TimeBar
@onready var label: Label = $Pivot/UI/Panel/TimeLabel

const BUY_TEX: Texture2D = preload("res://assets/sprites/buy hand.png")
const SELL_TEX: Texture2D = preload("res://assets/sprites/sell hand.png")

var is_buy: bool
var _time_left: float
var _ui_timer: Timer
var _dying: bool = false
var buy_sell_text: String = ""

signal finTimer(bool)

func _ready() -> void:
	# choose texture
	#movido a su papa para facilitar logica
	is_buy = (randi_range(0, 1) == 0)
	
	sprite.texture = BUY_TEX if is_buy else SELL_TEX
	# choose text
	buy_sell_text = "BUY!!!" if is_buy else "SELL!!!"
	
	

	# init timer ui
	_time_left = lifetime
	bar.min_value = 0.0
	bar.max_value = 1.0
	bar.value = 1.0
	_update_ui()

	_ui_timer = Timer.new()
	_ui_timer.wait_time = update_rate
	_ui_timer.one_shot = false
	_ui_timer.autostart = true
	_ui_timer.timeout.connect(_tick_ui)
	add_child(_ui_timer)

	# schedule despawn
	get_tree().create_timer(lifetime).timeout.connect(_begin_despawn)

func _tick_ui() -> void:
	_time_left = maxf(0.0, _time_left - update_rate)
	_update_ui()

func _update_ui() -> void:
	var ratio: float = 0.0 if lifetime <= 0.0 else (_time_left / lifetime)
	bar.value = ratio
	label.text = "%0.1f" % _time_left + " " + buy_sell_text

func _exit_tree() -> void:
	finTimer.emit(is_buy)

func _begin_despawn() -> void:
	print("begindespawn")
	if _dying:
		return
	_dying = true

	if _ui_timer:
		_ui_timer.stop()
	

	var t := create_tween()
	t.tween_property(self, "modulate:a", 0.0, fade_out_time)
	t.finished.connect(queue_free)
