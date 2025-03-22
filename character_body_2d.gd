extends CharacterBody2D
class_name Player
@onready var animated_sprite = $Sprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION  = 800.0
const FRICTION = 900.0
const AIR_RESISTANCE = 300.0 
const AIR_ACCELERATION = 400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	
	apply_gravity(delta)
	handle_jump()
	handle_acceleration(direction, delta)
	handle_air_acceleration(direction, delta)
	apply_friction(direction, delta)
	apply_air_resistance(delta)
	move_and_slide()
	handle_animation()
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY

func apply_friction(direction, delta):
	if direction == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

func apply_air_resistance(delta):
	if velocity.x != 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, AIR_RESISTANCE * delta)	

func handle_acceleration(direction, delta):
	if not is_on_floor(): 
		return
	if direction != 0:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)

func handle_air_acceleration(direction, delta):
	if is_on_floor(): return
	if direction != 0:
		velocity.x = move_toward(velocity.x, SPEED * direction, AIR_ACCELERATION * delta)

func handle_animation():
	if velocity.x != 0: 
		animated_sprite.play("walk")
		if velocity.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")
