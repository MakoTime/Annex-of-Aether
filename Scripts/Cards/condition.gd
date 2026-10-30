extends Resource
class_name Condition

static var EVENT_TARGET_IS_ADJACENT_ALLIED_HERO: Condition = Condition.new(&"event_target_is_adjacent_allied_hero", "the affected unit is an adjacent allied hero")
static var CAN_SWAP_WITH_EVENT_TARGET: Condition = Condition.new(&"can_swap_with_event_target", "this unit can swap with the affected unit")

@export var id: StringName = &""
@export var text: String = ""


func _init(condition_id: StringName = &"", condition_text: String = "") -> void:
	id = condition_id
	text = condition_text