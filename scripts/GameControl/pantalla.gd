extends Node2D

var precioShare: int= 0
var porcentajeCambio: int = 0
signal cambioPrecio(precioShare)
signal cambioPorcentajeCambio(porcentajeCambio) 


@export var letraPantalla: String = "":
	get:
		return letraPantalla
@export var precioPantalla  : int = 1000

func comprarPantalla () -> void:
	if (global.money >= precioPantalla) :
		global.lose_money(precioPantalla)
		global.money_changed.emit()
		visible  = true
	return

func _physics_process(delta: float) -> void:
	if visible == false and Input.is_action_just_pressed("wave" + letraPantalla) :
		comprarPantalla()

func _on_arrow_body_precio_accion(precio: int) -> void:
	precioShare = precio
	cambioPrecio.emit(precio)
func _on_arrow_body_porcentaje_accion(porcentaje: int) -> void:
	porcentajeCambio=porcentaje
	cambioPorcentajeCambio.emit(porcentajeCambio)
