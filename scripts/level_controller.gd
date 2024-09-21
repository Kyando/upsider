class_name LevelController
extends Node

@onready var objective: Goal = $Objective
@onready var scene_transition: SceneTransition = $SceneTransition

func _ready() -> void:
	objective.on_goal_reached.connect(go_to_next_level)

func go_to_next_level() -> void:
	scene_transition.load_next_level()
