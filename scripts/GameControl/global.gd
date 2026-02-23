# global.gd
extends Node

signal money_changed()
signal shares_changed()

var money: int = 1000
var shares: int = 0

func actualizar() -> void:
	shares_changed.emit()
	money_changed.emit()

func buy_shares(precio: int) -> void:
	money -= precio * 100
	shares += 100
	actualizar()
func sell_shaders(precio: int) -> void:
	if (shares>=100 ):
		money += precio * 100
		shares -= 100
		actualizar()
	
func gain_money(moneySum: int) -> void:
	money += moneySum
	actualizar()
func lose_money(moneySum: int) -> void:
	money -= moneySum
	actualizar()
