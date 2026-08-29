extends Node
class_name WeaponBehavior

var belong: Weapon

var game: GameNode:
	get: return Global.game

var belong_unit: UnitCommon:
	get: return belong.belong
