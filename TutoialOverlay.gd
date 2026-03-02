# TutorialOverlay.gd
extends CanvasLayer
class_name TutorialOverlay

signal finished

@export var slides: Array[Dictionary] = []
@export var pause_tree := true

@onready var title_label: Label = $Root/Panel/VBoxContainer/Title
@onready var image_rect: TextureRect = $Root/Panel/VBoxContainer/Image
@onready var body_label: RichTextLabel = $Root/Panel/VBoxContainer/Body

@onready var back_btn: Button = $Root/Panel/VBoxContainer/HBoxContainer/Back
@onready var next_btn: Button = $Root/Panel/VBoxContainer/HBoxContainer/Next
@onready var skip_btn: Button = $Root/Panel/VBoxContainer/HBoxContainer/Skip

var _index := 0

func _ready() -> void:
	# Safety check so you get a clear message instead of a null crash
	assert(back_btn != null and next_btn != null and skip_btn != null, "TutorialOverlay: Button nodes not found. Check node paths/names.")
	assert(title_label != null and image_rect != null and body_label != null, "TutorialOverlay: UI nodes not found. Check node paths/names.")

	back_btn.pressed.connect(_on_back)
	next_btn.pressed.connect(_on_next)
	skip_btn.pressed.connect(_on_skip)

	open()

func open() -> void:
	if slides.is_empty():
		_close()
		return

	_index = 0
	visible = true
	if pause_tree:
		get_tree().paused = true
	_render()
	next_btn.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_cancel"):
		_close()
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_accept"):
		_on_next()
	elif event.is_action_pressed("ui_left"):
		_on_back()

func _render() -> void:
	var s := slides[_index]
	title_label.text = s.get("title", "")
	body_label.text = s.get("text", "")
	image_rect.texture = s.get("texture", null)

	back_btn.disabled = (_index == 0)
	next_btn.text = "Finish" if _index == slides.size() - 1 else "Next"

func _on_back() -> void:
	if _index > 0:
		_index -= 1
		_render()

func _on_next() -> void:
	if _index < slides.size() - 1:
		_index += 1
		_render()
	else:
		_close()

func _on_skip() -> void:
	_close()

func _close() -> void:
	visible = false
	if pause_tree and get_tree():
		get_tree().paused = false
	finished.emit()
	queue_free()
