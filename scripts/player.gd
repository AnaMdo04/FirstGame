extends CharacterBody2D

@onready var shoot: Node2D = $Shoot
@onready var shoot_cool_down: Timer = $ShootCoolDown
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var game_manager: Node = get_parent().get_node("GameManager")

const ice2 = preload("res://scenes/ice_2.tscn")
const ice = preload("res://scenes/ice.tscn")

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var can_shoot = true

var is_alive = true

func _on_body_entered(body):
	if body.is_in_group("monsters") and is_alive:
		is_alive = false
		print("You died!")
		Engine.time_scale = 0.5
		queue_free()  # O la lógica que uses para eliminar al jugador
		# Aquí puedes llamar a la lógica de reinicio

func _ready() -> void:
	add_to_group("player")  # Añadir al grupo "player"
	if game_manager == null:
		print("Error: GameManager no encontrado.")
	shoot_cool_down.wait_time = 0.2
	shoot_cool_down.autostart = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	handle_movement()
	handle_animation()

	if Input.is_action_just_pressed("shoot"):
		shoot_raycast()
	if Input.is_action_just_pressed("shoot2"):
		shoot_impulse()

func handle_movement() -> void:
	var direction = Input.get_axis("move_left", "move_right")
	animated_sprite_2d.flip_h = direction < 0

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func handle_animation() -> void:
	var direction = Input.get_axis("move_left", "move_right")

	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")

func shoot_impulse() -> void:
	if not can_shoot:
		print("CoolDown: %.2f" % shoot_cool_down.time_left)
		return
	if game_manager.player_ammo <= 0:
		print("No Ammo")
		return

	var bala = ice2.instantiate()
	game_manager.use_ammo()  # Usa una bala y actualiza el contador
	bala.position = shoot.global_position

	var impulse_direction: Vector2
	if animated_sprite_2d.flip_h:
		impulse_direction = Vector2(-150, -400)
	else:
		impulse_direction = Vector2(150, -400)

	bala.apply_impulse(impulse_direction, Vector2.ZERO)
	bala.set_collision_layer(2)

	get_tree().root.add_child(bala)

	shoot_cool_down.start()
	can_shoot = false

func shoot_raycast() -> void:
	if not can_shoot:
		print("CoolDown: %.2f" % shoot_cool_down.time_left)
		return
	if game_manager.player_ammo <= 0:
		print("No Ammo")
		return

	var bala_temp = ice.instantiate()
	game_manager.use_ammo()  # Usa una bala y actualiza el contador
	bala_temp.position = shoot.global_position

	var bala_direction: Vector2
	if animated_sprite_2d.flip_h:
		bala_direction = Vector2(-1, 0)
	else:
		bala_direction = Vector2(1, 0)

	bala_temp.set_direction(bala_direction)
	bala_temp.set_collision_layer(2)

	get_parent().add_child(bala_temp)

	shoot_cool_down.start()
	can_shoot = false

func _on_shoot_cool_down_timeout() -> void:
	can_shoot = true
