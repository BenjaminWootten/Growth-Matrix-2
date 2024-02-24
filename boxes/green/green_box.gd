extends Area3D

@onready var green_box_root = self.get_parent()

func _on_ready():
	self.on_body_entered.connect(green_box_root._on_box_filled)

func _on_body_entered(body):
	$MeshInstance3D.mesh.material.albedo_color = Color(0.1, 0.9, 0.6, 1.0)

func _on_body_exited(body):
	$MeshInstance3D.mesh.material.albedo_color = Color(0.0, 0.55, 0.0, 1.0)
