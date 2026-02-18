# player.gd
extends CharacterBody2D

@export var speed_y := 300.0
@export var speed_x := 10.0

var going_up := false
var area : bool = 1

func _physics_process(_delta: float) -> void:
	# Toggle on key press
	if Input.is_action_just_pressed("wave"):
		going_up = !going_up

	velocity.y = -speed_y if going_up else speed_y
	velocity.x = speed_x
	rotation = -340 if going_up else 340
	move_and_slide()
	
	#gain money if area top, lose money if area bottom
	global.gain_money(1) if area else global.lose_money(1)
	#gain money if go up, lose money if go down
	global.gain_money(2) if velocity.y < 0 else global.lose_money(2)
	
	


#enter
func _on_area_lose_body_entered(body: Node2D) -> void:
	area = 0

func _on_area_gain_body_entered(body: Node2D) -> void:
	area = 1
