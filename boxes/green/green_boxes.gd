extends Node3D

@onready var total_boxes = self.get_child_count()
var filled_boxes = 0

func _on_green_box_body_entered(body):
	filled_boxes += 1
	if filled_boxes == total_boxes:
		print("level complete")
