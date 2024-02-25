extends Area3D

@onready var green_box_root = get_parent()

func _ready():
	self.body_entered.connect(green_box_root._on_green_box_body_entered)
	$MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate()
	$MeshInstance3D.mesh.material = $MeshInstance3D.mesh.material.duplicate()

func _on_body_entered(_body):
	$MeshInstance3D.mesh.material.albedo_color = Color(0.5, 0.25, 0.8, 1.0)

func _on_body_exited(_body):
	$MeshInstance3D.mesh.material.albedo_color = Color(0.0, 0.55, 0.0, 1.0)
