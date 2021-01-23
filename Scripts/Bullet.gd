extends Area2D

var shoot = false

const DAMAGE = 50
export var SPEED = 2500


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)


func _physics_process(delta):
	position += transform.x * SPEED * delta


func _on_Bullet_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
		queue_free()
	else:
		queue_free()


func _on_Timer_timeout():
	queue_free()
