extends Node


func reset_level() -> void:
	get_tree().reload_current_scene()



func _on_body_entered(body: Node2D) -> void:
	reset_level()
