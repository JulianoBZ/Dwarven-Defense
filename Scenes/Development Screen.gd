extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var farm_count = 0
var woodcutter_count = 0
var brewer_count = 0
var blacksmith_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_buildings():
	farm_count = 0
	woodcutter_count = 0
	brewer_count = 0
	blacksmith_count = 0
	var wood = 0
	var iron = 0
	var drink = 0
	var food = 0
	for n in get_children():
		if n.is_in_group("building_button") && n.get_node("Built_Tower").get_child_count() > 0:
			match n.get_node("Built_Tower").get_child(0).b_name:
				"Farm":
					farm_count += 1
					food += n.get_node("Built_Tower").get_child(0).generate_resource()
				"Wood Cutter":
					woodcutter_count += 1
					wood += n.get_node("Built_Tower").get_child(0).generate_resource()
				"Brewer":
					brewer_count += 1
					drink += n.get_node("Built_Tower").get_child(0).generate_resource()
				"Blacksmith":
					blacksmith_count += 1
					iron += n.get_node("Built_Tower").get_child(0).generate_resource()
	Global.pass_turn(wood,iron,drink,food)


func _on_Next_turn_pressed():
	get_buildings()
	get_parent().wave_start()
	print("Farms: "+str(farm_count))
	print("Wood Cutters: "+str(woodcutter_count))
	print("Brewers: "+str(brewer_count))
	print("Blacksmiths: "+str(blacksmith_count))
	
	#Global.pass_turn(woodcutter_count,blacksmith_count,brewer_count,farm_count)


func _on_To_Defense_pressed():
	get_parent().get_node("Camera2D").make_current()
