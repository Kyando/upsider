extends Area2D

const LEVELS_FOLDER_PATH = "res://scenes/levels/level_"


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		load_next_level()


func load_next_level() -> void:
	var current_file = get_tree().current_scene.scene_file_path
	var next_level = current_file.to_int() + 1

	print(next_level)
	var next_level_path = LEVELS_FOLDER_PATH + str(next_level) + ".tscn" 
	print(next_level_path)
	get_tree().change_scene_to_file(next_level_path)
	
	
