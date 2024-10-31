extends Area2D

@onready var timer: Timer = $Timer

var speed = 300
var direction = Vector2(1, 0)

func _ready() -> void:
	timer.start()
	self.area_entered.connect(_on_area_entered)

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area):
	print("Colisión con: ", area.name)  # Para debug
	if area.is_in_group("monsters") or area.get_parent().is_in_group("monsters"):
		print("¡Monstruo eliminado!")
		area.get_parent().queue_free()  # Eliminar al monstruo
		queue_free()  # Eliminar el proyectil
