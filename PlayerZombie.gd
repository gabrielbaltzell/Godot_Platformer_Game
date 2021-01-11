extends KinematicBody2D

export var MAX_SPEED = 300
var JUMP = 500
var FRICTION = .2
var ACCELERATION = 500
var GRAVITY = 700
const AIR_RESISTANCE = .1
const MAXIMAL_WALKABLE_SLOPE_ANGLE = 50

onready var rayCast = $RayCast2D

var floor_normal = Vector2()
var normal = Vector2()

var velocity = Vector2.ZERO


func _ready():
	pass # Replace with function body.
	

func _physics_process(delta):
	
	floor_normal = get_floor_normal()
	if is_on_floor():
		if floor_normal.y > -1:
			GRAVITY = 250
		else: GRAVITY = 700
	else: GRAVITY = 700
	
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	
	if input_x != 0:
		velocity.x += input_x * ACCELERATION * delta
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	velocity.y += GRAVITY * delta
		
	if is_on_floor():
		if input_x == 0:
			velocity.x = lerp(velocity.x, 0, FRICTION)
		elif input_x > 0 and velocity.x < 0:
			velocity.x = lerp(velocity.x, 0, FRICTION)
		elif input_x < 0 and velocity.x > 0:
			velocity.x = lerp(velocity.x, 0, FRICTION)
			
		if Input.is_action_just_pressed("jump"):
			velocity.y = -JUMP
	else:
		if Input.is_action_just_released("jump") and velocity.y < -JUMP/2:
			velocity.y = -JUMP/2
			
		
		if input_x == 0:
			velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
			
	if rayCast.is_colliding():
		normal = rayCast.get_collision_normal()
		var slope_angle = rad2deg((acos(normal.dot(Vector2(0, -1)))))
		print(slope_angle)
		if slope_angle < MAXIMAL_WALKABLE_SLOPE_ANGLE:
			if input_x == 0:
				if slope_angle > 0:
					GRAVITY = 0
					velocity.y = lerp(velocity.y, 0, FRICTION)
	print(rayCast.is_colliding())
		
	velocity = move_and_slide(velocity, Vector2.UP) 
	




