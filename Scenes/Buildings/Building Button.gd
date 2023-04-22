extends Node2D

var building = preload("res://Scenes/Buildings/Building.tscn")

var active_building

var constructed_type = null

@export var start_type = 10

var building_prices = [[0,1,2,2],[2,0,2,2],[0,0,0,4],[0,0,2,0]]
#wood iron drink food 2124

var building_upgrade_prices = [[[0,0,0,1],[0,0,0,1],[0,0,0,1]],[[0,0,0,1],[0,0,0,1],[0,0,0,1]],[[0,0,0,1],[0,0,0,1],[0,0,0,1]],[[0,0,0,1],[0,0,0,1],[0,0,0,1]]]

# Called when the node enters the scene tree for the first time.
func _ready():
	if start_type != 10:
		build(start_type)

func _process(_delta):
	enable_buy()
	if active_building != null:
		enable_upgrade()
	
	if Input.is_action_just_pressed("mouse1"):
		$Panel.hide()
		$Manage_Panel.hide()
	if $Built_Tower.get_child_count() > 0:
		enable_disable_build_button(true)
	else:
		enable_disable_build_button(false)

func _on_Build_Button_pressed():
	if $Built_Tower.get_child_count() == 0:
		$Panel.show()

func _on_building_but_1_button_down():
	constructed_type = 0
	build(constructed_type)

func _on_building_but_2_button_down():
	constructed_type = 1
	build(constructed_type)

func _on_building_but_3_button_down():
	constructed_type = 2
	build(constructed_type)

func _on_building_but_4_button_down():
	constructed_type = 3
	build(constructed_type)

#instancia a torre com construtor baseado no 'type' e muda o tooltip
func build(type):
	print("Type: ",type)
	var b = building.instantiate()
	b.building_type = type
	b.position.x += 24
	b.position.y += 24
	$Built_Tower.add_child(b)
	active_building = b
	
	Change_Manage_Building_Tooltip()
	Change_Upgrade_Building_Tooltip()
	
	var price = building_prices[type]
	Global.deduct_total_resources(price)

#Alterna o estado do botão de construir e de gerenciamento
func enable_disable_build_button(state):
	$"Build Button".disabled = state
	$"Build Button".visible = !state
	
	$"Manage_Building".disabled != state
	$"Manage_Building".visible = state
	
	if state == true:
		$"Build Button".tooltip_text = ""
	else: 
		$"Build Button".tooltip_text = "Place a Building Here!"

#Destrói a torre
func _on_destroy_button_button_down():
	$Built_Tower.get_child(0).queue_free()
	$Manage_Building.tooltip_text = ""

#Exibe menu de gerenciamento
func _on_Manage_Building_pressed():
	$Manage_Panel.show()

#Upgrade na torre caso o level dela seja menor que 3
func _on_upgrade_button_button_down():
	if $Built_Tower.get_child(0).upgrade_lvl < 1:
		$Built_Tower.get_child(0).upgrade_lvl += 1
		
		Global.deduct_total_resources([1,1,1,1])
		Change_Manage_Building_Tooltip()
		Change_Upgrade_Building_Tooltip()

#Modifica o tooltip para fornecer informações da torre
func Change_Manage_Building_Tooltip():
	$Manage_Building.tooltip_text = "Upgrade lvl: "+str($Built_Tower.get_child(0).upgrade_lvl)+"\n"
	$Manage_Building.tooltip_text += "Resource Amount = "+str(active_building.generate_resource()) 
	pass

func Change_Upgrade_Building_Tooltip():
	print(active_building.upgrade_lvl)
	if active_building.upgrade_lvl == 1:
		$Manage_Panel/Upgrade_button.tooltip_text = "Upgrade lvl: (MAX)"+"\n"
		$Manage_Panel/Upgrade_button.tooltip_text += "Generated Resource = "+str(active_building.generate_resource()) 
		
		$Manage_Panel/Upgrade_button.disabled = true
	else:
		$Manage_Panel/Upgrade_button.tooltip_text = "Upgrade lvl: "+str(active_building.upgrade_lvl)+" -> "+str(active_building.upgrade_lvl+1)+"\n"
		$Manage_Panel/Upgrade_button.tooltip_text += "Generated Resource = "+str(active_building.generate_resource(active_building.upgrade_lvl+1))
		
	pass

func enable_buy():
	var can_buy
	var building_counter = 0
	
	for each in building_prices:
		can_buy = true
		var counter = 0
		for price in each:
			if (Global.total_resources[counter]) >= price && can_buy == true:
				can_buy = true
			else:
				can_buy = false
			counter+=1
		if can_buy:
			$Panel.get_child(building_counter).disabled = false
		else:
			$Panel.get_child(building_counter).disabled = true
		building_counter += 1

func enable_upgrade():
	var can_buy
	var upgrade_lvl = active_building.upgrade_lvl
	var building_type = active_building.building_type
	
	for each in building_upgrade_prices[building_type]:
		can_buy = true
		var counter = 0
		for price in each[upgrade_lvl]:
			if (Global.total_resources[counter]) >= price && can_buy == true:
				can_buy = true
			else:
				can_buy = false
		if can_buy:
			$Manage_Panel/Upgrade_button.disabled = false
		else:
			$Manage_Panel/Upgrade_button.disabled = true

func _on_building_but_1_button_up():
	pass # Replace with function body.
