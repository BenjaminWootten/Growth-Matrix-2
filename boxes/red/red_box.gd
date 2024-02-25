extends RigidBody3D

@onready var red_box_root = self.get_parent()
@onready var red_boxes = red_box_root.get_children()

var is_growing = false
var is_shrinking = false
var grown = false
@onready var initial_position = Vector3(self.position)

var x_growth
var y_growth
var z_growth

var x_offset
var y_offset
var z_offset

var frozen = []

const GROW_SPEED = 0.05
const SIZE_MAX = 3 - 0.025
const SIZE_MIN = 1
const RAY_LENGTH = 1

func grow_start():
	is_growing = true
	red_box_root.set_meta("clickable", false)
	self.freeze = false
	
	for i in red_boxes.size():
		if red_boxes[i] == self:
			red_box_root.set_meta("grown_box", i)

func shrink_start():
	is_shrinking = true
	red_box_root.set_meta("clickable", false)
	self.freeze = false

func _physics_process(_delta):
	if $MeshInstance3D.scale.y >= SIZE_MAX and is_growing:
		is_growing = false
		grown = true
		self.freeze = true
		red_box_root.set_meta("clickable", true)
		for box in frozen:
			box.freeze  = false
			box.set_collision_layer_value(1, false)
	
	if $MeshInstance3D.scale.y <= SIZE_MIN and is_shrinking:
		is_shrinking = false
		self.freeze = true
		self.position = initial_position
		grown = false
		red_box_root.set_meta("clickable", true)
	
	if is_growing:
		$MeshInstance3D.scale += Vector3(x_growth, y_growth, z_growth)
		$CollisionShape3D.shape.size += Vector3(x_growth, y_growth, z_growth)
	
	if is_shrinking:
		$MeshInstance3D.scale += Vector3(-x_growth, -y_growth, -z_growth)
		$CollisionShape3D.shape.size += Vector3(-x_growth, -y_growth, -z_growth)
		self.position += Vector3(x_offset, y_offset, z_offset)


func clicked():
	if red_box_root.get_meta("clickable"):
		# Check if there is already a grown box, shrink it if there is
		if red_box_root.get_meta("grown_box") >= 0:
			red_boxes[red_box_root.get_meta("grown_box")].shrink_start()
			red_box_root.set_meta("grown_box", -1)
		
		if $MeshInstance3D.scale.y <= SIZE_MAX:
			# Check the collisions in each direction and adjust the growth amount
			var x_positive_growth = check_collision(Vector3(1,0,0), self)
			var x_negative_growth = check_collision(Vector3(-1,0,0), self)
			x_growth =  x_positive_growth + x_negative_growth
			
			var y_negative_growth = check_collision(Vector3(0,-1,0), self)
			y_growth = y_negative_growth * 2
			
			var z_positive_growth = check_collision(Vector3(0,0,1), self)
			var z_negative_growth = check_collision(Vector3(0,0,-1), self)
			z_growth = z_positive_growth + z_negative_growth
			
			# Set offset based on collisions, allows moving back to original
			# position if pushed during growth
			if x_positive_growth == 0:
				x_offset = GROW_SPEED/4
			elif x_negative_growth == 0:
				x_offset = -GROW_SPEED/4
			else:
				x_offset = 0
			
			if y_negative_growth:
				y_offset = -GROW_SPEED/2
			else:
				y_offset = 0
			
			if z_positive_growth == 0:
				z_offset = GROW_SPEED/4
			elif z_negative_growth == 0:
				z_offset = -GROW_SPEED/4
			else:
				z_offset = 0
			
			grow_start()

# returns 0 if collided, and GROW_SPEED/2 otherwise
func check_collision(axis: Vector3, origin_box):
	var end_offset = Vector3(RAY_LENGTH, RAY_LENGTH, RAY_LENGTH)
	end_offset *= axis
	
	var space_state = get_world_3d().direct_space_state
	
	var start_point = origin_box.position
	var end_point = origin_box.position + end_offset
	var ray = PhysicsRayQueryParameters3D.create(start_point, end_point)
	var collision = space_state.intersect_ray(ray)
	
	if collision:
		var collider = collision.collider
		if collider.get_meta("boxtype") == "white":
			return 0
		
		elif collider.get_meta("boxtype") == "red":
			#check if the collider is grown and its center is not adjacent, ignore collision if both are true
			if collider.grown:
				if Vector2(self.position.x, self.position.z).distance_to(Vector2(collider.initial_position.x, collider.initial_position.z)) > 1.1:
					return GROW_SPEED/2
			return 0
			
		elif collider.get_meta("boxtype") == "blue":
			var blue_chain_result = check_collision(axis, collider)
			if blue_chain_result == 0:
				collider.freeze = true
				collider.set_collision_layer_value(1, true)
				frozen.append(collider)
			return blue_chain_result
	return GROW_SPEED/2

