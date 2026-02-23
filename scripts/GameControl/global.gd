# global.gd
extends Node

signal money_changed()
signal shares_changed()

var money: int = 1000
var shares: int = 0

func buy_shares(precio: int) -> void:
	money -= precio * 100
	shares += 100
	shares_changed.emit()
func sell_shaders(precio: int) -> void:
	money += precio * 100
	shares -= 100
	shares_changed.emit()
	

func gain_money(moneySum: int) -> void:
	money += moneySum
	money_changed.emit()

func lose_money(moneySum: int) -> void:
	money -= moneySum
	money_changed.emit()
