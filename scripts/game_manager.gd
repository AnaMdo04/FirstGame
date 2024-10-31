extends Node

var score = 0
var player_ammo = 10

@onready var score_label = $ScoreLabel
@onready var ammo_label = $CanvasLayer/Ammo_label

func _ready() -> void:
	print(ammo_label)
	update_ammo_display()

func add_point():
	score += 1
	score_label.text = "Conseguiste " + str(score) + " monedas."

func use_ammo():
	if player_ammo > 0:
		player_ammo -= 1
		update_ammo_display() 
	else:
		print("No ammo left!")

func update_ammo_display():
	if ammo_label: 
		ammo_label.text = "Balas: " + str(player_ammo) + "/10" 
	else:
		print("Error: AmmoLabel no está inicializado.")
