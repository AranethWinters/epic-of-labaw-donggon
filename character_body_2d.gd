extends CharacterBody2D

@onready var grapple_controller := $GrappleController

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 0.1
const DECELERATION = 0.1

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and (is_on_floor() or grapple_controller.launched):
		velocity.y = JUMP_VELOCITY
		grapple_controller.Retract()

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = lerp(velocity.x, SPEED*direction, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION)

	move_and_slide()
