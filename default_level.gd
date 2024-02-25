extends Node3D


func _on_green_boxes_level_end():
	self.set_meta("level_active", false)
