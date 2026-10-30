extends Resource
class_name PassiveActionData

@export var id: StringName = &""
@export var effect: Effect = Effect.BUFF_STAT
@export var target: Target = Target.SELF
@export var amount: int = 1
@export var stat: StringName = &"attack"
@export var status: StringName = &""
@export var tags: Array[StringName] = []