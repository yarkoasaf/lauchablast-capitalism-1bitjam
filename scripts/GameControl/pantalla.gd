extends Node2D

var precioShare: int= 0
var porcentajeCambio: int = 0
signal cambioPrecio(precioShare)
signal cambioPorcentajeCambio(porcentajeCambio) 


@export var letraPantalla: String = "":
	get:
		return letraPantalla



func _on_arrow_body_precio_accion(precio: int) -> void:
	precioShare = precio
	cambioPrecio.emit(precio)
func _on_arrow_body_porcentaje_accion(porcentaje: int) -> void:
	porcentajeCambio=porcentaje
	cambioPorcentajeCambio.emit(porcentajeCambio)
