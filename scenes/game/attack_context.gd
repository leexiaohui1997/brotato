class_name AttackContext

var game: GameNode
var target: UnitCommon
var source: UnitCommon

var target_is_player: bool:
	get: return game and game.player == target

var source_is_player: bool:
	get: return game and game.player == source

static func create(
	_game: GameNode,
	_target: UnitCommon,
	_source: UnitCommon
) -> AttackContext:
	var ctx := AttackContext.new()
	ctx.game = _game
	ctx.target = _target
	ctx.source = _source
	return ctx
