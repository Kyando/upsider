extends Node


func reset_level() -> void:
	print(" e ai")
	get_tree().reload_current_scene()
	
	pass



func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		reset_level()
