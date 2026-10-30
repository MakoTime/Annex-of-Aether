class_name EncounterCard extends Node2D

@export var Name: String = "Card Name"
@export var Cost: int = 1
@export var Description: String = "New Description"
@export var CardImage: Node2D

@onready var cost_label: Label = $Cost/Label
@onready var name_label: Label = $Name/Label
@onready var description_label: Label = $Description/Label

func card_flip():
	pass

func _ready():
	cost_label.text = str(Cost)
	name_label.text = Name
	description_label.text = Description
	
