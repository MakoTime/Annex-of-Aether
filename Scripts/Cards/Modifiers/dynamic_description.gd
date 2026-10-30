extends Node


func format_passive(passive: PassiveData, resolved_amounts: Dictionary = {}) -> String:
	if passive == null:
		return ""

	var action_phrases: PackedStringArray = []
	for action in passive.actions:
		if action == null:
			continue
		var amount: int = int(resolved_amounts.get(action.id, action.amount))
		action_phrases.append(_format_action(action, amount))
	if action_phrases.is_empty():
		return ""

	var condition_phrases: PackedStringArray = []
	for condition in passive.conditions:
		match condition:
			PassiveData.Condition.EVENT_TARGET_IS_ADJACENT_ALLIED_HERO:
				condition_phrases.append("the affected unit is an adjacent allied hero")
			PassiveData.Condition.CAN_SWAP_WITH_EVENT_TARGET:
				condition_phrases.append("this unit can swap with the affected unit")

	var trigger_text: String = ""
	match passive.trigger:
		PassiveData.Trigger.AFTER_HIT:
			trigger_text = "After this unit is hit"
		PassiveData.Trigger.ON_HIT:
			trigger_text = "When this unit hits a target"
		PassiveData.Trigger.BEFORE_ATTACK_DAMAGE:
			trigger_text = "Before an attack deals damage"
		PassiveData.Trigger.TURN_START:
			trigger_text = "At the start of this unit's turn"
		PassiveData.Trigger.TURN_END:
			trigger_text = "At the end of this unit's turn"

	var text: String = trigger_text + ", "
	if not condition_phrases.is_empty():
		text += "if " + " and ".join(condition_phrases) + ", "
	text += ", then ".join(action_phrases) + "."
	if not passive.display_name.is_empty():
		text = passive.display_name + ": " + text
	return text


func _format_action(action: PassiveActionData, amount: int) -> String:
	var target: Target = action.target if action.target != null else Target.SELF
	var target_text: String = target.text

	match action.effect:
		PassiveActionData.Effect.BUFF_STAT:
			if target.id == &"self":
				return "gain %d %s" % [amount, String(action.stat).capitalize()]
			return "grant %s %d %s" % [target_text, amount, String(action.stat).capitalize()]
		PassiveActionData.Effect.AFFLICT:
			return "apply %d %s to %s" % [amount, String(action.status), target_text]
		PassiveActionData.Effect.HEAL:
			return "heal %s for %d" % [target_text, amount]
		PassiveActionData.Effect.SWAP:
			return "swap places with %s" % target_text
		PassiveActionData.Effect.REDIRECT_DAMAGE:
			return "take the damage instead of %s" % target_text
	return ""
