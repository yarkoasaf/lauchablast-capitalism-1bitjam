# global.gd
extends Node

signal money_changed(new_money: int)

var money: int = 20000000

	

func gain_money(moneySum: int) -> void:
	money += moneySum
	money_changed.emit()

func lose_money(moneySum: int) -> void:
	money -= moneySum
	money_changed.emit()
