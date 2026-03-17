extends StaticBody3D

@onready var original_position = position
@export var max_distance = 3
@export var speed = 1
@export var vector_direction = Vector3.LEFT

func _physics_process(delta):
	position = position + (vector_direction * delta)
	
	if position.distance_to(original_position) > max_distance:
		vector_direction *= -1
