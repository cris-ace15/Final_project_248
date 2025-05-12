extends Node2D



func _on_transition_door_body_entered(body: Node2D) -> void:
	if body.name == "Character":  # or use 'is Character' if using custom class
		print("Player touched door!")
		get_tree().change_scene_to_file("res://Towerlevel2.tscn")
