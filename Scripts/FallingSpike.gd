extends Area2D

var state = IDLE

var _gravity = 4000
var speed = 600
var velocity = Vector2()
var direction = 1

enum{
	IDLE
	FALL
}

func change_state(target_state: int):
	state = target_state

func set_direction(dir):
	direction = dir

func _physics_process(delta):
	if $RayCast2D.is_colliding():
		change_state(FALL)
	match state:
		IDLE:
			pass
		FALL:
			#print("Falling")
			velocity.y = speed * delta * direction
			translate(velocity)

func _on_Node2D_body_entered(body):
	if body.is_in_group("Tilemap"):
		queue_free()
