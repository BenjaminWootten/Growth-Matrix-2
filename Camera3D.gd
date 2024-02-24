extends Node3D

@onready var cam = $Camera3D
var pivot_point = self

var panning = false
var previous_mouse_pos = Vector2(0,0)

const RAY_LENGTH = 20

func _input(event):
	if event.is_action_pressed("mouse_left"):
		var hit = cast_ray(event.position)
		if hit:
			if hit.has_method("clicked"):
				hit.clicked()
			else:
				pan_start()
	elif event.is_action("scroll_up"):
		cam.position.z -= 0.5
	elif event.is_action("scroll_down"):
		cam.position.z += 0.5

func cast_ray(mouse_pos):
	var space_state = get_world_3d().direct_space_state
	
	var start_point = cam.project_ray_origin(mouse_pos)
	var end_point = start_point + cam.project_ray_normal(mouse_pos) * RAY_LENGTH
	var ray = PhysicsRayQueryParameters3D.create(start_point, end_point)
	
	var collision = space_state.intersect_ray(ray)
	if collision:
		return collision.collider
	pan_start()
	return null

func pan_start():
	panning = true

func _physics_process(delta):
	if panning:
		var mouse_pos = get_viewport().get_mouse_position()
		if previous_mouse_pos:
			var movement = (mouse_pos - previous_mouse_pos)/500
			pivot_point.rotation.x -= movement.y
			pivot_point.rotation.y -= movement.x
		previous_mouse_pos = mouse_pos
		if Input.is_action_just_released("mouse_left"):
			panning = false
			previous_mouse_pos = Vector2(0,0)

