extends KinematicBody2D

export var MAX_SPEED = 300
var JUMP = 650
var FRICTION = .2
var ACCELERATION = 1000
var GRAVITY = 700
const AIR_RESISTANCE = .1
const MAXIMAL_WALKABLE_SLOPE_ANGLE = 60

onready var rayCast = $RayCast2D
onready var bullet = preload("res://Scenes/Bullet.tscn")
onready var muzzle = $Muzzle


var floor_normal = Vector2()
var normal = Vector2()

var velocity = Vector2.ZERO

func _ready():
	Engine.set_target_fps(Engine.get_iterations_per_second())
	

func _physics_process(delta):
	
	if Input.is_action_just_pressed("fire"):
		shoot()
		
	
#	floor_normal = get_floor_normal()
#	if is_on_floor():
#		if floor_normal.y > 5:
#			GRAVITY = 250
#		else: GRAVITY = 700
#	else: GRAVITY = 700
	
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
		if slope_angle < MAXIMAL_WALKABLE_SLOPE_ANGLE and slope_angle > 30:
			if input_x == 0 and not Input.is_action_just_pressed("jump"):
				velocity.x = 0
				velocity.y = 0
	print(rayCast.is_colliding())
		
	velocity = move_and_slide(velocity, Vector2.UP) 
	

func shoot():
	var b = bullet.instance()
	owner.add_child(b)
	b.transform = $Muzzle.global_transform
	b.look_at(get_global_mouse_position())



