extends Node2D

@export var rest_length = 2.0
@export var stiffness = 10.0
@export var damping = 2.0

@onready var ray := $RayCast2D
@onready var player := get_parent()
@onready var rope := $Line2D

var launched = false
var target : Vector2

func Launch():
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()

func Retract():
	launched = false
	rope.hide()

func Handle_Grapple(delta):
	var target_direction = player.global_position.direction_to(target)
	var target_distance = player.global_position.distance_to(target)
	var displacement = target_distance - rest_length
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_direction * spring_force_magnitude
		var velocity_dot = player.velocity.dot(target_direction)
		var damping = -damping * velocity_dot * target_direction
		
		force = spring_force + damping
		
	player.velocity += force * delta
	Update_Rope()
	
func Update_Rope():
	rope.set_point_position(1,to_local(target))

func _process(delta):
	ray.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("left_click"):
		Launch()
	if Input.is_action_just_released("left_click"):
		Retract()
	
	if launched:
		Handle_Grapple(delta)
