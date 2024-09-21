class_name SceneTransition
extends CanvasLayer

const LEVELS_FOLDER_PATH = "res://scenes/levels/level_"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dissolve_rect: ColorRect = $DissolveRect


func load_next_level() -> void:
#	Gets next scene file
	var current_file = get_tree().current_scene.scene_file_path
	var next_level = current_file.to_int() + 1
	var next_level_path = LEVELS_FOLDER_PATH + str(next_level) + ".tscn" 
	
#	Play animation and change scenes
	animation_player.play('dissolve')
	await animation_player.animation_finished
	get_tree().change_scene_to_file(next_level_path)
	
