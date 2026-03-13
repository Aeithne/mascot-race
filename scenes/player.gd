extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
@export var player_camera : Camera3D
var direction = Vector3.ZERO
var target_velocity = Vector3.ZERO
@onready var camera_distance = player_camera.position - self.position

func _physics_process(delta):
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	player_camera.position = player_camera.position.lerp(position + camera_distance, delta)
	player_camera.rotation = player_camera.rotation.lerp(player_camera.rotation * direction, delta)


func _on_control_analogic_changed(value: Vector2, distance: float, angle: float, angle_clockwise: float, angle_not_clockwise: float) -> void:
	direction = Vector3(value.x, 0, value.y)
