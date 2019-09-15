class_name Player
extends KinematicBody2D


# All units in pxs
export (float) var max_speed = 250.0
export (float) var max_falling_speed = 1000.0
export (float) var min_speed = 15.0
export (float) var stop_speed = 0.40
export (float) var acceleration = 200.0
export (float) var gravity = 900.0

var speed = Vector2()


func _physics_process(delta):
	var nothing_pressed = true
	if Input.is_action_pressed("ui_right"):
		nothing_pressed = false
		speed.x += acceleration * delta
	if Input.is_action_pressed("ui_left"):
		nothing_pressed = false
		speed.x -= acceleration * delta
	
	if nothing_pressed:
		if speed.length() <= min_speed:
			speed = Vector2()
		else:
			speed.x = sign(speed.x) * (abs(speed.x) - stop_speed * delta)
	
	speed.x = clamp(speed.x, -max_speed, max_speed)
	move_and_slide(speed, Vector2(0, -1))
	
	if is_on_floor():
		speed.y = 0.3
		if Input.is_action_pressed("ui_up"):
			jump(Vector2(0, 0))
	else:
		speed.y = min(speed.y + gravity * delta, max_falling_speed)
	
	print(speed)


func jump(force):
	pass
