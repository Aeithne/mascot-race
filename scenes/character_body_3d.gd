extends CharacterBody3D

@export var active_camera: Camera3D
@onready var position_x = self.position.x

var distance_limit = 8.0

func _physics_process(delta):
	move_and_slide()
	
func follow(player, speed, offset_y, turn_angle):
	self.velocity = speed
	self.position.y = offset_y
	var predicted_position = position
	predicted_position.x = predicted_position.x - turn_angle
	if predicted_position.distance_to(player.position) <= distance_limit:
		self.position.x = lerp(position.x, predicted_position.x, 1)
	
	active_camera.look_at(player.position)
	#print(rotation.y)
	
func recenter(player):
	var distance = self.position.x - player.position.x
	print(distance)
	#position.x = lerp(position.x, player.position.x, 0.1)
	#active_camera.look_at(player.position)
	if distance > 0:
		self.position.x -= abs(distance) * 0.08
	if distance < 0:
		self.position.x += abs(distance) * 0.08
	if abs(distance) * 1000 < 1:
		self.position.x = player.position.x
	active_camera.look_at(player.position)
	
