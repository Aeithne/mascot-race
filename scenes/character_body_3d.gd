extends CharacterBody3D

func _physics_process(delta):
	move_and_slide()
	
func follow(speed, offset_y):
	self.velocity = speed
	self.position.y = offset_y
	print(position)
