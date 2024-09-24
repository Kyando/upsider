extends Area2D
class_name Goal 


signal on_goal_reached

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		on_goal_reached.emit()
	
	
