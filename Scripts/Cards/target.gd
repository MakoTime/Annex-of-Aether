extends Resource
class_name Target

static var SELF: Target = Target.new(&"self", "this unit")
static var EVENT_TARGET: Target = Target.new(&"event_target", "the affected unit")
static var EVENT_SOURCE: Target = Target.new(&"event_source", "the triggering source")
static var ALL_ALLIES: Target = Target.new(&"all_allies", "all allies")

@export var id: StringName = &"self"
@export var text: String = "this unit"


func _init(target_id: StringName = &"self", target_text: String = "this unit") -> void:
	id = target_id
	text = target_text