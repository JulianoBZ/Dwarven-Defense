extends Node2D


var farm = preload("res://Assets/Sprites/Buildings/Farm.png")
var woodcutter = preload("res://Assets/Sprites/Buildings/Woodcutter.png")
var brewer = preload("res://Assets/Sprites/Buildings/Brewer.png")
var blacksmith = preload("res://Assets/Sprites/Buildings/Blacksmith.png")

var building_type = 0

var resource = 0

var upgrade_lvl = 0

var total_value = 0 

var b_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	match building_type:
		0:
			$Sprite2D.texture = woodcutter
			b_name = "Wood Cutter"
		1:
			$Sprite2D.texture = blacksmith
			b_name = "Blacksmith"
		2:
			$Sprite2D.texture = brewer
			b_name = "Brewer"
		3:
			$Sprite2D.texture = farm
			b_name = "Farm"
#widf

#wood iron drink food 2124

func generate_resource(lvl = 0):
	var resource_lvl
	resource_lvl = upgrade_lvl
	if lvl != 0:
		resource_lvl = lvl
		
	match building_type:
		0:
			match resource_lvl:
				0:
					resource = 2
				1:
					resource = 3
				2:
					resource = 4
				3:
					resource = 6
			return resource
		1:
			match resource_lvl:
				0:
					resource = 1
				1:
					resource = 2
				2:
					resource = 3
				3:
					resource = 5
			return resource
		2:
			match resource_lvl:
				0:
					resource = 2
				1:
					resource = 3
				2:
					resource = 4
				3:
					resource = 6
			return resource
		3:
			match resource_lvl:
				0:
					resource = 4
				1:
					resource = 5
				2:
					resource = 6
				3:
					resource = 8
			return resource

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
