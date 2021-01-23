extends Camera2D

var margin_left = 0.3
var margin_right = 0.7

var right_limit = 1000000
var left_limit = -1000000
var top_limit = -1000000
var bottom_limit = 1000000

var screen_size


func _ready():
	screen_size = self.get_viewport_rect().size
	

func update_viewport():
	var canvas_transform = self.get_viewport().get_canvas_transform()
	canvas_transform.o = - self.get_global_position() + screen_size / 2
	self.get_viewport().set_canvas_transform(canvas_transform)
	

func update_camera(character_position):
	var new_camera_position = self.get_global_position()
	
	if character_position > self.get_global_position().x + screen_size.width * (margin_right - 0.5):
		new_camera_position.x = character_position.x - screen_size.width * (margin_right - 0.5)
		
	elif character_position.x < self.get_global_position().x + screen_size.width * (margin_left - 0.5):
		new_camera_position.x = character_position.x + screen_size.width * (0.5 - margin_left)
		
	new_camera_position.x = clamp(new_camera_position.x, left_limit + screen_size.width * 0.5, right_limit - screen_size.width * 0.5)
	new_camera_position.y = clamp(new_camera_position.y, top_limit + screen_size.height * 0.5, bottom_limit - screen_size.height * 0.5)
	
	self.set_global_position(new_camera_position)
