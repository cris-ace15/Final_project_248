extends TextureRect

func _process(delta):
	if Input.is_action_just_pressed("start"):
		get_tree().change_scene_to_file("res://intro_text.tscn")
