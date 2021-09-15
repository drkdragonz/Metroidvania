extends Area2D


func _physics_process(delta):
	if Input.is_action_just_pressed("left"):
		self.scale = Vector2(-1, 1)
	if Input.is_action_just_pressed("right"):
		self.scale = Vector2(1, 1)
