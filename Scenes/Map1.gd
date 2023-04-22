extends Node2D

var wave = 1
var wave_tick = 0
var arr_all_waves = [[2, 0, 2, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 1, 1, 0, 2, 99], [2, 0, 2, 0, 1, 1, 1, 2, 0, 0, 1, 0, 2, 2, 0, 0, 2, 99], [2, 2, 0, 1, 1, 0, 1, 1, 0, 0, 3, 99], [3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 99], [3, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 2, 2, 2, 1, 1, 99]]

@onready var arq = "res://wave_info/map1.txt"
@onready var enemy = preload("res://Scenes//Enemies//Test_Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.update_total_resources(5,5,5,5)
#	load_file(arq)

func _process(_delta):
	$VillageHealth.text = "Village Health : "+str(Global.village_health)
	$VillageHealth2.text = "Village Health : "+str(Global.village_health)
	if Global.village_health <= 0:
		$WaveLabel.hide()
		$WaveLabel2.hide()
		$LosingScreen.show()
		get_node("Camera2D").make_current()
		$"To Development".disabled = true
		$"Next_turn".disabled = true
	#Check Wave Progress
	if $Path2D.get_child_count() == 0 && arr_all_waves[wave-1][wave_tick] == 99:
		print("Next Wave")
		next_wave()

func next_wave():
	print("Wave Over!")
	wave += 1
	$WaveLabel.text = "Wave: "+str(wave)
	$WaveLabel2.text = "Wave: "+str(wave)
	wave_tick = 0
	$wave_timer.stop()
	$"Development Screen".get_buildings()
	get_node("Next_turn").disabled = false
	$"Development Screen/Next_turn".disabled = false
	if wave == 5:
		$WaveLabel.hide()
		$WaveLabel2.hide()
		$WinningScreen.show()
		get_node("Camera2D").make_current()
		$"To Development".disabled = true
		$"Next_turn".disabled = true

#func load_file(file):
#	var f = FileAccess.open(file, FileAccess.READ)
#	for i in range(5):
#		var content = f.get_line()
#		var treated_content = content.split(" ")
#		var treated_wave = []
#		for each in treated_content:
#			treated_wave.append(int(each))
#		arr_all_waves.append(treated_wave)
#	print(arr_all_waves)
		

func wave_start():
	$wave_timer.start()
	wave_tick += 1
	$Next_turn.disabled = true
	$"Development Screen/Next_turn".disabled = true
	

func _input(event):
	if event.is_action_pressed("Space"):
		change_camera()

func change_camera():
	if get_node("Camera2D").is_current():
		$"Development Screen".get_node("Camera2D").make_current()
	else:
		get_node("Camera2D").make_current()

func spawn_enemy(type):
	if type != 0:
		var e = enemy.instantiate()
		e.enemy_type = type
		$Path2D.add_child(e)
	else:
		pass

func _on_Area2D_body_entered(body):
	if body.get_parent().is_in_group("enemy"):
		print(body)


func _on_To_Development_pressed():
	$"Development Screen".get_node("Camera2D").make_current()


func _on_next_turn_pressed():
	wave_start()


func _on_wave_timer_timeout():
	if arr_all_waves[wave-1][wave_tick] != 99:
		spawn_enemy(arr_all_waves[wave-1][wave_tick])
		$wave_timer.start()
		wave_tick += 1
