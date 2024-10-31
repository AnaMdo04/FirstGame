extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	if body.is_in_group("player"):  # Solo reiniciar si es el jugador
		print("You died!")
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()  # O la lógica que uses para eliminar al jugador
		timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
