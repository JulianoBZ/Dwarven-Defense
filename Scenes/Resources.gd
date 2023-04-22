extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Wood.text = "Wood: "+str(Global.total_resources[0])
	$Iron.text = "Iron: "+str(Global.total_resources[1])
	$Drink.text = "Drink: "+str(Global.total_resources[2])
	$Food.text = "Food: "+str(Global.total_resources[3])
