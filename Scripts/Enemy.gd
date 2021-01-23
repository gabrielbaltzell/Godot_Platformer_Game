extends RigidBody2D

var health = 100

func _ready():
	pass


func _process(delta):
	if health <= 0:
		queue_free()


func _on_Enemy_body_entered(body):
	pass # Replace with function body.
