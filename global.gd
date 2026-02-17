# global.gd
extends Node

signal money_changed(new_money: int)

var money: int = 0

func gain_money(moneySum: int) -> void:
	money += moneySum
	money_changed.emit(money)

func lose_money(moneySum: int) -> void:
	money -= moneySum
	money_changed.emit(money)
