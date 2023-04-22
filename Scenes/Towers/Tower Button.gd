extends Node2D


@onready var tower = preload("res://Scenes/Towers/Tower.tscn")

var active_tower

var constructed_type = null

var tower_prices = [[2,0,0,2],[2,2,2,0],[2,0,5,1],[2,4,2,0]]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Sempre que o mouse é clicado, dentro ou fora do menu, fecha o menu
func _process(_delta):
	enable_buy()
	if active_tower != null:
		enable_upgrade()
	
	if Input.is_action_just_pressed("mouse1"):
		$Panel.hide()
		$Manage_Panel.hide()
	if $Built_Tower.get_child_count() > 0:
		enable_disable_build_button(true)
	else:
		enable_disable_build_button(false)

#Exibe o menu de construção assim que é clicado
func _on_Build_Button_pressed():
	print("TOWER BUTTON PRESSED")
	if $Built_Tower.get_child_count() == 0:
		$Panel.show()
		$"Build Button".hide()

#Constrói torre baseado no botão apertado
func _on_tower_but_1_button_down():
	constructed_type = 0
	build(constructed_type)

func _on_tower_but_2_button_down():
	constructed_type = 1
	build(constructed_type)

func _on_tower_but_3_button_down():
	constructed_type = 2
	build(constructed_type)

func _on_tower_but_4_button_down():
	constructed_type = 3
	build(constructed_type)

#instancia a torre com construtor baseado no 'type' e muda o tooltip
func build(type):
	print("BUILDING")
	var t = tower.instantiate()
	t.tower_type = type
	t.position.x += 24
	t.position.y += 24
	$Built_Tower.add_child(t)
	active_tower = t
	print(active_tower)
	Change_Manage_Building_Tooltip()
	Change_Upgrade_Building_Tooltip()
	
	var price = tower_prices[type]
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
		$"Build Button".tooltip_text = "Build a Tower Here!"

#Destrói a torre
func _on_destroy_button_button_down():
	$Built_Tower.get_child(0).queue_free()
	$Manage_Building.tooltip_text = ""

#Exibe menu de gerenciamento
func _on_Manage_Building_pressed():
	$Manage_Panel.show()

#Upgrade na torre caso o level dela seja menor que 3
func _on_upgrade_button_button_down():
	if $Built_Tower.get_child(0).upgrade_lvl < 3:
		$Built_Tower.get_child(0).upgrade_lvl += 1
		$Built_Tower.get_child(0).upgrade_action()
		
		Change_Manage_Building_Tooltip()
		Change_Upgrade_Building_Tooltip()
		
		var price = active_tower.tower_upgrade_prices[active_tower.tower_type][active_tower.upgrade_lvl-1]
		Global.deduct_total_resources(price)

#Modifica o tooltip para fornecer informações da torre
func Change_Manage_Building_Tooltip():
	$Manage_Building.tooltip_text = "Upgrade lvl: "+str($Built_Tower.get_child(0).upgrade_lvl)+"\n"
	$Manage_Building.tooltip_text += "Atk Interval: "+str($Built_Tower.get_child(0).get_node("Timer").wait_time)+"\n"
	$Manage_Building.tooltip_text += "Damage: "+str($Built_Tower.get_child(0).damage)+"\n"
	$Manage_Building.tooltip_text += "DPS: "+str($Built_Tower.get_child(0).damage / $Built_Tower.get_child(0).get_node("Timer").wait_time)
	pass

func Change_Upgrade_Building_Tooltip():
	print(active_tower.upgrade_lvl)
	if active_tower.upgrade_lvl == 3:
		$Manage_Panel/Upgrade_button.tooltip_text = "Upgrade lvl: 3(MAX)"
		$Manage_Panel/Upgrade_button.tooltip_text += "Atk Interval: "+str(active_tower.get_node("Timer").wait_time)+"\n"
		$Manage_Panel/Upgrade_button.tooltip_text += "Damage: "+str(active_tower.damage)+"\n"
		$Manage_Panel/Upgrade_button.tooltip_text += "DPS: "+str( active_tower.damage / active_tower.get_node("Timer").wait_time)

		$Manage_Panel/Upgrade_button.disabled = true
	else:
		$Manage_Panel/Upgrade_button.tooltip_text = "Upgrade lvl: "+str(active_tower.upgrade_lvl)+" -> "+str(active_tower.upgrade_lvl+1)+"\n"
		$Manage_Panel/Upgrade_button.tooltip_text += "Atk Interval: "+str(active_tower.get_node("Timer").wait_time)+" -> "+str(active_tower.tower_upgrade_values[active_tower.tower_type][active_tower.upgrade_lvl+1][0]) +"\n"
		$Manage_Panel/Upgrade_button.tooltip_text += "Damage: "+str(active_tower.damage)+" -> "+ str(active_tower.tower_upgrade_values[active_tower.tower_type][active_tower.upgrade_lvl+1][1])+"\n"
		$Manage_Panel/Upgrade_button.tooltip_text += "DPS: "+str( active_tower.damage / active_tower.get_node("Timer").wait_time)+" -> "+str((active_tower.tower_upgrade_values[active_tower.tower_type][active_tower.upgrade_lvl+1][1])/(active_tower.tower_upgrade_values[active_tower.tower_type][active_tower.upgrade_lvl+1][0]))+"\n"
		$Manage_Panel/Upgrade_button.tooltip_text += "Upgrade Cost: "+str(active_tower.tower_upgrade_prices[active_tower.tower_type][active_tower.upgrade_lvl])
	pass

func enable_buy():
	var can_buy
	var tower_counter = 0
	
	for each in tower_prices:
		can_buy = true
		var counter = 0
		for price in each:
			if (Global.total_resources[counter]) >= price && can_buy == true:
				can_buy = true
			else:
				can_buy = false
			counter+=1
		if can_buy:
			$Panel.get_child(tower_counter).disabled = false
		else:
			$Panel.get_child(tower_counter).disabled = true
		tower_counter += 1
	
func enable_upgrade():
	var can_buy
	var upgrade_lvl = active_tower.upgrade_lvl
	var tower_type = active_tower.tower_type
	
	for each in active_tower.tower_upgrade_prices[tower_type]:
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
	
#var tower_upgrade_prices = [[[2,0,1,1],[3,1,2,2],[3,2,4,2]],[[0,1,2,2],[0,2,4,4],[0,3,6,4]]]
