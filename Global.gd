extends Node

var wood = 0

var iron = 0

var drink = 0

var food = 0

var village_health = 20

var total_resources = []
# Called when the node enters the scene tree for the first time.
func _ready():
	total_resources = [wood,iron,drink,food]
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pass_turn(wood_b,iron_b,drink_b,food_b):
	wood = total_resources[0]
	iron = total_resources[1]
	drink = total_resources[2]
	food = total_resources[3]
	
	wood += (wood_b)
	iron += (iron_b)
	drink += (drink_b)
	food += (food_b)
	update_total_resources(wood,iron,drink,food)
	print("Total Resources: ",total_resources)
	
func update_total_resources(w,i,d,f):
	total_resources = [w,i,d,f]

func deduct_total_resources(price):
	total_resources[0] -= price[0]
	total_resources[1] -= price[1]
	total_resources[2] -= price[2]
	total_resources[3] -= price[3]
	print("Total Resources: ",total_resources)
