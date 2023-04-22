extends Node2D

var bullet = preload("res://Scenes/Towers/Bullet.tscn")

var ballista = preload("res://Assets/Sprites/Ballista.png")
var cannon = preload("res://Assets/Sprites/Cannon.png")
var mage = preload("res://Assets/Sprites/mage_tower.png")
var gun = preload("res://Assets/Sprites/gun1.png")
var gunShoot = preload("res://Assets/Sprites/gun2.png")

var can_fire = true

var tower_type = 0

var atk_speed = 0

var damage = 0

var range_multiplier = 1

var upgrade_lvl = 0

var total_value = 0 

var upgrade_ballista = [[0.5,2],[0.4,2],[0.3,2],[0.2,2]]

var upgrade_cannon = [[1,3],[1,4],[1,5],[0.7,6]]

var upgrade_mage = [[1.2,5],[1.2,6],[1,7],[0.8,10]]

var upgrade_gun = [[0.2,1],[0.2,1.5],[0.1,1.5],[0.1,2.5]]

var tower_upgrade_values =[[[0.5,2],[0.4,2],[0.3,2],[0.2,2]],[[1,3],[1,4],[1,5],[0.7,6]],[[1.2,5],[1.2,6],[1,7],[0.8,10]],[[0.2,1],[0.2,1.5],[0.1,1.5],[0.1,2.5]]]

var tower_upgrade_prices = [[[2,0,1,1],[3,1,2,2],[3,2,4,2]],[[0,1,2,2],[0,2,4,4],[0,3,6,4]],[[2,1,1,2],[3,0,4,0],[4,0,8,0]],[[2,4,2,0],[2,6,2,0],[2,10,4,0]]]

#Construtor da instância
func _ready():
	match tower_type:
		0:
			$Timer.wait_time = upgrade_ballista[upgrade_lvl][0]
			damage = upgrade_ballista[upgrade_lvl][1]
			$Node2D/"Tower-Top".texture = ballista
			range_multiplier = 2
		1:
			$Timer.wait_time = upgrade_cannon[upgrade_lvl][0]
			damage = upgrade_cannon[upgrade_lvl][1]
			$Node2D/"Tower-Top".texture = cannon
			range_multiplier = 1.2
		2:
			$Timer.wait_time = upgrade_mage[upgrade_lvl][0]
			damage = upgrade_mage[upgrade_lvl][1]
			$Node2D/"Tower-Top".texture = mage
			range_multiplier = 1.5
		3:
			$Timer.wait_time = upgrade_gun[upgrade_lvl][0]
			damage = upgrade_gun[upgrade_lvl][1]
			$Node2D/"Tower-Top".texture = gun
			range_multiplier = 1.5
			
	$Area2D/Tower_Range.scale = Vector2(range_multiplier,range_multiplier)
	pass

#Verifica a todo frame se existe um inimigo na área, e se pode atirar, e instancia um projétil com alvo
func _process(_delta):
	var further = null
	var enemy_arr = [] 
	for a in $Area2D.get_overlapping_areas():
		if a.get_parent().is_in_group("enemy") && a.get_parent().alive == true:
			enemy_arr.append(a.get_parent())
			further = a.get_parent()
	for each in enemy_arr:
		if enemy_arr.size() > 1:
			if further.progress_ratio < each.progress_ratio:
				further = each
		if enemy_arr.size() == 1:
			further = each
	
	if can_fire && further != null:
		if tower_type != 2:
			$Node2D.look_at(further.global_position)
		spawn_bullet(further)
		can_fire = false
		$Timer.start()
		if tower_type == 3:
			$"Node2D/Tower-Top".texture = gunShoot
	if can_fire && tower_type == 3:
		$"Node2D/Tower-Top".texture = gun

#Contador da taxa de tiro
func _on_Timer_timeout():
	can_fire = true

#Instancia projétil fornecendo um alvo
func spawn_bullet(enemy):
	var b = bullet.instantiate()
	b.tower_type = tower_type
	b.global_position = global_position
	b.target = enemy
	b.damage = damage
	b.tower_type = tower_type
	$Projectiles.add_child(b)
	pass

#Upgrade da torre baseado no array de upgrades
func upgrade_action():
	match tower_type:
		0:
			$Timer.wait_time = upgrade_ballista[upgrade_lvl][0]
			damage = upgrade_ballista[upgrade_lvl][1]
		1:
			$Timer.wait_time = upgrade_cannon[upgrade_lvl][0]
			damage = upgrade_cannon[upgrade_lvl][1]
		2:
			$Timer.wait_time = upgrade_mage[upgrade_lvl][0]
			damage = upgrade_mage[upgrade_lvl][1]
