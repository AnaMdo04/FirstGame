extends Area2D

@export var scene: String

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scenes/" + scene + ".tscn")
pass