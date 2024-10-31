extends Node

var score = 0
var player_ammo = 10  # Inicializar con 10 balas

@onready var score_label = $ScoreLabel
@onready var ammo_label = $CanvasLayer/Ammo_label  # Asegúrate de que este nodo exista en tu escena

func _ready() -> void:
	print(ammo_label)  # Para depuración, verifica que no sea null
	update_ammo_display()  # Actualiza la interfaz de balas al inicio

func add_point():
	score += 1
	score_label.text = "Conseguiste " + str(score) + " monedas."

func use_ammo():
	if player_ammo > 0:
		player_ammo -= 1
		update_ammo_display()  # Actualiza la interfaz de balas
	else:
		print("No ammo left!")

func update_ammo_display():
	if ammo_label:  # Verifica que ammo_label esté inicializado
		ammo_label.text = "Balas: " + str(player_ammo) + "/10"  # Actualiza el texto de balas
	else:
		print("Error: AmmoLabel no está inicializado.")
