extends Resource
class_name Effect

static var BUFF_STAT: Effect = Effect.new(&"buff_stat", "grant {target} {amount} {stat}", "gain {amount} {stat}")
static var AFFLICT: Effect = Effect.new(&"afflict", "apply {amount} {status} to {target}")
static var HEAL: Effect = Effect.new(&"heal", "heal {target} for {amount}")
static var SWAP: Effect = Effect.new(&"swap", "swap places with {target}")
static var REDIRECT_DAMAGE: Effect = Effect.new(&"redirect_damage", "take the damage instead of {target}")

@export var id: StringName = &""
@export var text: String = ""
@export var self_text: String = ""


func _init(effect_id: StringName = &"", effect_text: String = "", effect_self_text: String = "") -> void:
	id = effect_id
	text = effect_text
	self_text = effect_self_text
