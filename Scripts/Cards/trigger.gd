extends Resource
class_name Trigger

static var AFTER_HIT: Trigger = Trigger.new(&"after_hit", "After this unit is hit")
static var ON_HIT: Trigger = Trigger.new(&"on_hit", "When this unit hits a target")
static var BEFORE_ATTACK_DAMAGE: Trigger = Trigger.new(&"before_attack_damage", "Before an attack deals damage")
static var TURN_START: Trigger = Trigger.new(&"turn_start", "At the start of this unit's turn")
static var TURN_END: Trigger = Trigger.new(&"turn_end", "At the end of this unit's turn")

@export var id: StringName = &""
@export var text: String = ""


func _init(trigger_id: StringName = &"", trigger_text: String = "") -> void:
	id = trigger_id
	text = trigger_text
