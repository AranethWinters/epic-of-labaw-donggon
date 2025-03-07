extends CharacterBody2D

@onready var grapple_controller := $GrappleController

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 0.1
const DECELERATION = 0.1
const GRAVITY = 980

func Hook_Process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click") and not hooked:
		ray_cast_2d.target_position = to_local(get_global_mouse_position())
		ray_cast_2d.force_raycast_update()
		if ray_cast_2d.is_colliding():
			hooked = true
			#get values from raycast
			var hook_pos = ray_cast_2d.get_collision_point()
			var collider = ray_cast_2d.get_collider()
			
			if collider.is_in_group("Hookable"):
				pinjoint.global_position = hook_pos
				hook.global_position = hook_pos
				pinjoint.node_b = get_path_to(hook)
				#rotate the hook so it is the right angle
				var direction = hook_pos - global_position
				hook.rotation = direction.angle()
	elif Input.is_action_just_released("shoot") and hooked:
		hooked = false	
		pinjoint.node_b = NodePath("")
	if hooked:
		line.clear_points()
		line.add_point(Vector2.ZERO)
		line.add_point(to_local(line_end.global_position))
	else:
		line.clear_points()
		
	var grounded = get_slide_collision_count()>0

func _physics_process(delta):
	Hook_Process(delta)
  
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or grapple_controller.launched):
		velocity.y = JUMP_VELOCITY * delta
		grapple_controller.Retract()

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = lerp(velocity.x, SPEED*direction, ACCELERATION * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION * delta)

	move_and_slide()
  