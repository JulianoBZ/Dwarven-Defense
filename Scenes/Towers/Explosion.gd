extends AnimatedSprite2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#Inicia a animação assim que é instanciado
func _ready():
	play()

#deleta assim que a aanimação termina
func _on_Explosion_animation_finished():
	queue_free()
