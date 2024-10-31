extends RigidBody2D

@onready var timer: Timer = $Timer

var speed = 300
var direction = Vector2(1, 0)

func _ready() -> void:
	timer.start()
	set_direction(direction)

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()
	apply_impulse(Vector2.ZERO, direction * speed)

func _on_timer_timeout() -> void:
	queue_free()  # Eliminar el proyectil después de un tiempo

func _on_body_entered(body):
	print("Colisión con: ", body.name)  # Para depuración
	if body.is_in_group("monsters"):
		print("¡Monstruo eliminado!")
		body.queue_free()  # Eliminar el monstruo
	else:
		print("No es un monstruo: ", body.name)
	queue_free()  # Eliminar el proyectil
