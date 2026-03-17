extends CharacterBody3D

# How fast the player moves in meters per second.
@export var max_speed = 14
@export var max_reverse_speed = -2
@export var max_turning_speed = 5
var f_speed = 0
var t_speed = 0
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
@export var player_camera : CharacterBody3D
@onready var current_analog : Vector2
var direction = Vector3.ZERO
var target_velocity = Vector3.ZERO
#@onready var camera_distance = player_camera.position - self.position

func _physics_process(delta):
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * t_speed
	#print(target_velocity.x)
	target_velocity.z = direction.z * f_speed
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
	player_camera.follow(self, velocity, position.y + 5.0, current_analog.x)
	deaccelerate(current_analog)
	#player_camera.position = player_camera.position.lerp(position + camera_distance, delta)
	#player_camera.rotation = player_camera.rotation.lerp(player_camera.rotation * direction, delta)

func change_speed(speed_rate):
	f_speed += speed_rate
	f_speed = clamp(f_speed, max_reverse_speed, max_speed)

func apply_turn(turn_intensity):
	t_speed += turn_intensity
	t_speed = clamp(t_speed, max_turning_speed * -1, max_turning_speed)
	#print(t_speed)
	
func deaccelerate(analog):
	if analog.y == 0 and f_speed > 0:
		f_speed = clamp(f_speed - 0.2, 0, f_speed)
	if analog.y == 0 and f_speed < 0:
		f_speed = clamp(f_speed + 0.2, f_speed, 0)
	if analog.x == 0:
		player_camera.recenter(self)
	if analog.x == 0 and t_speed > 0:
		t_speed = clamp(t_speed - 0.5, 0, t_speed)
	if analog.x == 0 and t_speed < 0:
		t_speed = clamp(t_speed + 0.5, t_speed, 0)

func _on_control_analogic_changed(value: Vector2, distance: float, angle: float, angle_clockwise: float, angle_not_clockwise: float) -> void:
	#direction = Vector3(0.0, 0, -1.0)
	change_speed(value.y * -1)
	apply_turn(value.x)
	#print(value)
	current_analog = value
	#direction = Vector3.FORWARD
	direction = Vector3(1.0, 0, -1.0)
