# Encounter Cards Design

2 main playable card types, units and effects.

## Units
Units represent an entity in battle, it can be a hero, a group of soldiers or even a building. Every unit has the following stats
 - Health, how many points of damage until destroyed
 - Attack, base attack modifier of the unit
 - Defence, base defence modifier of the unit
 - Aether, how much aether they are able to generate per turn
 - Cost, How much aether is costs to deploy them.

Units have 2 types of effects, active and passive

### Active
Active effects is a list of actions the unit takes in order, every round the unit performs the top most action, then puts it on the bottom of the list. Actions can be found in `# Actions`.
An example of an action list is:
 - Melee Attack front unit.
 - Move back if possible and shield unit in front
 - Shield self and move forwards.

Each unit can have any number of active actions, but they almost always go in order.

### Passive
Passive effects happen when triggered under certain conditions, for example a tag 'sacrificial' would mean if a hero unit is adjacent and attacked, then the unit will swap places and take the damage instead. Another can be 'When hit, raise attack by 1'


# Actions
Actions generally have 3 inputs: Effect(s), target(s) and amount(s)

## Effect
 - Melee (Hit unit in front if enemy)
 - Defend (Can target self or ally) generally base `Defence` stat
 - Move (Shift position with unit in front or behind it based on target direction)
 - Buff[stat] buffs a stat of a target
 - Heal (Replenishes HP)
 - Debuf[stat] reduces a stat
 - Afflict (Adds a status to target)

## Target
Targets can be relative or absolute, singular or multiple, targeting others or self. It can be adjacent units, front units or single 'back line' unit. And many more.

## Amount
Generally they are based on a units stat but not always, can be a static number (Although can be raised if something increases 'tagged' effects for example a heal effect that originally 'heal 1').
Formula generally is amount = (stat + modifier) * multiplier.
