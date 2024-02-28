extends Node3D

@onready var total_boxes = self.get_child_count()
var filled_boxes = 0

signal level_end

func _on_green_box_body_entered(_body):
	filled_boxes += 1
	await get_tree().create_timer(0.1).timeout
	if filled_boxes == total_boxes:
		print("level complete")
		level_end.emit()

func _on_green_box_body_exited(_body):
	filled_boxes -= 1
