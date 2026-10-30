extends SceneTree

const Formatter = preload("res://Scripts/Cards/Modifiers/dynamic_description.gd")
const CardDefinition = preload("res://Scripts/Cards/Encounter/card_data.gd")

var failures: int = 0


func _init() -> void:
	var formatter := Formatter.new()
	var retaliation := load("res://Assets/Cards/Passives/retaliation.tres") as PassiveData
	var sacrificial := load("res://Assets/Cards/Passives/sacrificial.tres") as PassiveData
	_check(retaliation != null, "Retaliation resource loads")
	_check(sacrificial != null, "Sacrificial resource loads")
	if retaliation == null or sacrificial == null:
		formatter.free()
		quit(1)
		return

	_check(formatter.format_passive(retaliation) == "After this unit is hit, gain 1 Attack.", "Base buff wording")
	_check(formatter.format_passive(retaliation, {&"attack_buff": 3}) == "After this unit is hit, gain 3 Attack.", "Resolved amount override")
	_check(retaliation.actions[0].amount == 1, "Formatting leaves shared data unchanged")
	_check(formatter.format_passive(sacrificial) == "Sacrificial: Before an attack deals damage, if the affected unit is an adjacent allied hero and this unit can swap with the affected unit, swap places with the affected unit, then take the damage instead of the affected unit.", "Keyword, conditions and action order")

	var poison := PassiveActionData.new()
	poison.id = &"poison"
	poison.effect = Effect.AFFLICT
	poison.target = Target.EVENT_TARGET
	poison.status = &"poison"
	poison.amount = 2
	var burn := PassiveActionData.new()
	burn.id = &"burn"
	burn.effect = Effect.AFFLICT
	burn.target = Target.EVENT_TARGET
	burn.status = &"burn"
	var on_hit := PassiveData.new()
	on_hit.trigger = Trigger.ON_HIT
	on_hit.actions.assign([poison, burn])
	var expected := "When this unit hits a target, apply 3 poison to the affected unit, then apply 1 burn to the affected unit."
	_check(formatter.format_passive(on_hit, {&"poison": 3}) == expected, "Multiple afflictions and targeted override")
	_check(formatter.format_passive(on_hit, {&"poison": 3}) == expected, "Repeated rendering is deterministic")
	_check(formatter.format_passive(PassiveData.new()).is_empty(), "Empty passive has no description")
	_check(formatter.format_passive(null).is_empty(), "Missing passive has no description")

	_check(Target.ALL_ALLIES.text == "all allies", "Target contains its display text")
	_check(Target.ALL_ALLIES.id == &"all_allies", "Target has a stable gameplay identifier")
	var group_heal := PassiveActionData.new()
	group_heal.effect = Effect.HEAL
	group_heal.target = Target.ALL_ALLIES
	group_heal.amount = 2
	var healing := PassiveData.new()
	healing.trigger = Trigger.TURN_START
	healing.actions.append(group_heal)
	_check(formatter.format_passive(healing) == "At the start of this unit's turn, heal all allies for 2.", "Formatter uses target wording")
	group_heal.target = Target.new(&"front_ally", "the ally in front")
	_check(formatter.format_passive(healing) == "At the start of this unit's turn, heal the ally in front for 2.", "Custom targets need no formatter changes")
	var buff := PassiveActionData.new()
	buff.target = Target.SELF.duplicate() as Target
	var self_buff := PassiveData.new()
	self_buff.actions.append(buff)
	_check(formatter.format_passive(self_buff) == "After this unit is hit, gain 1 Attack.", "Self targeting uses stable ID rather than resource identity")
	buff.target = null
	_check(formatter.format_passive(self_buff) == "After this unit is hit, gain 1 Attack.", "Missing target defaults to self")

	_check(Effect.AFFLICT.text == "apply {amount} {status} to {target}", "Effect owns its template")
	_check(Trigger.ON_HIT.text == "When this unit hits a target", "Trigger owns its wording")
	_check(Condition.CAN_SWAP_WITH_EVENT_TARGET.text == "this unit can swap with the affected unit", "Condition owns its wording")
	_check(sacrificial.trigger.id == Trigger.BEFORE_ATTACK_DAMAGE.id, "Serialized trigger retains gameplay ID")
	_check(sacrificial.conditions[0].id == Condition.EVENT_TARGET_IS_ADJACENT_ALLIED_HERO.id, "Serialized condition retains gameplay ID")
	_check(sacrificial.actions[0].effect.id == Effect.SWAP.id, "Serialized effect retains gameplay ID")
	var custom_action := PassiveActionData.new()
	custom_action.id = &"shield_allies"
	custom_action.effect = Effect.new(&"shield", "give {target} {amount} shield")
	custom_action.target = Target.ALL_ALLIES
	custom_action.amount = 2
	var custom_passive := PassiveData.new()
	custom_passive.trigger = Trigger.new(&"on_deploy", "When deployed")
	custom_passive.conditions.append(Condition.new(&"low_health", "this unit has low health"))
	custom_passive.actions.append(custom_action)
	var custom_expected := "When deployed, if this unit has low health, give all allies 3 shield."
	_check(formatter.format_passive(custom_passive, {&"shield_allies": 3}) == custom_expected, "Custom definitions render without formatter branches")
	_check(custom_action.amount == 2, "Custom formatting leaves authored amounts unchanged")
	custom_passive.conditions.append(null)
	_check(formatter.format_passive(custom_passive, {&"shield_allies": 3}) == custom_expected, "Missing conditions are skipped")
	custom_action.effect = null
	_check(formatter.format_passive(custom_passive).is_empty(), "Missing effects produce no dangling wording")

	var card := CardDefinition.new()
	var other_card := CardDefinition.new()
	card.passives.append(retaliation)
	_check(card.passives[0] == retaliation, "Card holds passive definitions")
	_check(other_card.passives.is_empty(), "Cards have independent passive lists")
	formatter.free()
	if failures == 0:
		print("All passive checks passed.")
	quit(0 if failures == 0 else 1)


func _check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)