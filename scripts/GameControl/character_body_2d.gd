# player.gd
extends CharacterBody2D

@export var speed_y := 300.0
@export var mapaLocal : TileMapLayer = null
signal precioAccion(precio:int)
signal porcentajeAccion(porcentaje:int)
@onready var Sprite = $ArrowSprite
var going_up := false
var precioCambio:= 0
var ultimoPrecio:= 0
var letraPantalla: String = ""

func _ready() -> void:
	letraPantalla =get_parent().get("letraPantalla")
	print(letraPantalla)

func calcularPrecio() -> void:
	if mapaLocal == null:
		return
		

	var tile_coords = mapaLocal.local_to_map(position)
	var precio = tile_coords.y *-1
	#precio corresponde a la posicion de la flecha dentro de MapaLocal
	
	var porcentaje = 0.0
	porcentaje = ((precio - precioCambio) / float(precioCambio)) * 100.0
	#porcentaje de cambio desde el ultimo movimiento, como en las cosas de inversores de verdad
	
	porcentajeAccion.emit(porcentaje)
	precioAccion.emit(precio)
	ultimoPrecio = precio
	

#maneja movimiento de la flecha
func _physics_process(_delta: float) -> void:
	# Toggle on key press
	if Input.is_action_just_pressed("wave" + letraPantalla):
		going_up = !going_up
		Sprite.rotation_degrees = 75 if velocity.y < 0 else -75
		precioCambio = ultimoPrecio

	velocity.y = -speed_y if going_up else speed_y
	move_and_slide()
	calcularPrecio()

	
