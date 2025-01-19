class_name Item extends Resource

@export_group("Item Info")
@export var item_name: String = ""
@export_enum("Common","Uncommon","Rare","Epic") var rarity: String

@export_group("Drop stats")
@export var droppable: bool = false
@export_range(0,1000) var drop_min: int = 0
@export_range(0,1000) var drop_max: int = 0
@export_range(0,100) var drop_chance: float = 0
