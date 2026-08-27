extends Node
class_name Behavior

var belong: UnitCommon

var game: GameNode:
	get: return Global.game

var player: UnitCommon:
	get: return null if not game else game.player
