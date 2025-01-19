class_name Stats extends Resource

@export_group("Info")
@export_enum("Player","Peasant","Militia","Knight","Archer","MiniBoss","Boss") var type
@export var entity_name: String = ""

@export_group("Attributes")
@export var health: float = 40.0
@export var mana: float = 10.0
@export var attack: int = 5
@export var defense: int = 1

@export_group("Misc")
@export_subgroup("Drops")
@export_enum("Coines","Food","Blood","Pocket Lint") var resource_dropped: Array[String] = []


#	//STAT FUNCTIONS//
func takeDamage(amount) -> void:
	health -= amount

#	//MISC FUNCTIONS//
