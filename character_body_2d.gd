# player.gd
extends CharacterBody2D

@export var speed_y := 300.0

var going_up := false

func _physics_process(_delta: float) -> void:
	# Toggle on key press
	if Input.is_action_just_pressed("wave"):
		going_up = !going_up

	velocity.y = -speed_y if going_up else speed_y
	rotation = -340 if going_up else 340
	move_and_slide()
	
	global.gain_money(1) if velocity.y < 0 else global.lose_money(1)
