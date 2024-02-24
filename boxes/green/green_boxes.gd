extends Node3D

var total_boxes = self.get_child_count()
var filled_boxes = 0

func _on_box_filled():
	print("a")
	filled_boxes += 1
	if filled_boxes == total_boxes:
		print("woohoo")
