extends PathFollow2D

var health = 0
var t = 0
var speed = 0
var enemy_type = 0
var alive = true
var damage = 1

func _ready():
	rotates = false
	loop = false
	match enemy_type:
		1:
			speed = 150
			health = 10.0
			damage = 1
		2:
			speed = 80
			health = 25.0
			scale = Vector2(1.5,1.5)
			damage = 3
		3:
			speed = 40
			health = 100.0
			scale = Vector2(2.5,2.5)
			damage = 10

func _process(delta):
	if alive == true:
		t += delta
		progress = t * speed
	
	if progress_ratio == 1:
		queue_free()
		Global.village_health -= damage
	
	if health <= 0 && alive:
		alive = false
		$Sprite2D.rotation_degrees = 90
		$Death_Timer.start()
	
	for n in $Area2D.get_overlapping_bodies():
		if n.is_in_group("bullet"):
			damage_self(n.damage)
			n.queue_free()

func damage_self(dmg):
	health -= dmg


func _on_Death_Timer_timeout():
	queue_free()
