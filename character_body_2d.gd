extends CharacterBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var hook_speed = 10
@export var hook: StaticBody2D
@export var pinjoint: PinJoint2D
@onready var line = $Line2D
var hooked= false;
@onready var line_end = hook.get_node("Marker2D2")

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
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
	var direction = Input.get_axis("move_left", "move_right")
	Hook_Process(delta)
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * delta)

	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * delta)
	
	move_and_slide()
