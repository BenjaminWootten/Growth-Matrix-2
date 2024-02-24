extends Area3D

var hitboxes_touched = 0

func _on_body_entered(body):
	$MeshInstance3D.mesh.material.albedo_color = Color(0.1, 0.9, 0.6, 1.0)

func _on_body_exited(body):
	$MeshInstance3D.mesh.material.albedo_color = Color(0.0, 0.55, 0.0, 1.0)

