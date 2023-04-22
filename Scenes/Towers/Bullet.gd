extends RigidBody2D

var target = null
var tower_type = 0
var speed = 0
var damage = 0
var target_location = null
@onready var lifetime = $Timer

var ballista_arrow = preload("res://Assets/Sprites/Ballista_arrow.png")
var cannon_ball = preload("res://Assets/Sprites/Cannon_Ball.png")
var mage_ball = preload("res://Assets/Sprites/mage_ball.tres")
var bullet = preload("res://Assets/Sprites/bullet.png")

var explosion = preload("res://Scenes/Towers/Explosion.tscn")


#Define onde está o alvo, velocidade do projétil, textura e regra da área de colisão
func _ready():
	lifetime.wait_time = 1.2
	target_location = target.global_position
	match tower_type:
		0:
			speed = 500
			#damage = 2
			$Sprite2D.texture = ballista_arrow
			$AnimatedSprite2D.visible = false
		1:
			speed = 300
			$Sprite2D.texture = cannon_ball
			$CollisionShape2D.scale = Vector2(8,8)
			$CollisionShape2D.disabled = true
			$AnimatedSprite2D.visible = false
		2:
			speed = 250
			$Sprite2D.visible = false
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.play()
		3:
			speed = 800
			#damage = 2
			$Sprite2D.texture = bullet
			$AnimatedSprite2D.visible = false
			lifetime.wait_time = 0.2

#Comportamento do projétil baseado na torre que a atirou
func _process(delta):
	if target_location != null:
		match tower_type:
			0:
				look_at(target.global_position)
				position = position.move_toward(target.global_position,speed * delta)
			1:
				look_at(target_location)
				position = position.move_toward(target_location,speed * delta)
				if global_position == target_location:
					detonate()
			2:
				look_at(target.global_position)
				position = position.move_toward(target.global_position,speed * delta)
			3: 
				look_at(target_location)
				position = position.move_toward(target_location,speed * delta)
	else:
		queue_free()

#Ativa a área de colisão da bomba
func detonate():
	var e = explosion.instantiate()
	e.global_position = global_position
	get_parent().add_child(e)
	$CollisionShape2D.disabled = false
	
	pass


func _on_animated_sprite_2d_animation_finished():
	if tower_type == 2:
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.play()
