extends Resource
class_name PassiveData

@export var id: StringName = &""
@export var keyword: StringName = &""
@export var display_name: String = ""
@export var trigger: Trigger = Trigger.AFTER_HIT
@export var conditions: Array[Condition] = []
@export var actions: Array[PassiveActionData] = []