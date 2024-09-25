extends Node2D
class_name Portal


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("invert_gravity"):
		body.invert_gravity(position.y, true)
