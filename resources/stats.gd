class_name Stats extends Resource

@export_group("Info")
@export_enum("Player","Peasant","Militia","Knight","Archer","MiniBoss","Boss") var type
@export var entity_name: String = ""

@export_group("Attributes")
@export var max_health: float = 40.0
@export var current_health: float = 40.0
@export var max_mana: float = 10.0
@export var current_mana: float = 10.0
@export var attack: int = 5
@export var defense: int = 1

@export_group("Misc")
@export_subgroup("Drops")
@export_enum("Coins","Food","Blood","Pocket Lint") var resource_dropped: Array[String] = []

signal no_health

#	//STAT FUNCTIONS//
func takeDamage(amount) -> void:
	print(amount)
	current_health -= amount
	if(current_health < 0):
		no_health.emit()

#	//MISC FUNCTIONS//
