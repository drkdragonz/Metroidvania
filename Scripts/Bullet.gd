extends Area2D

const RIGHT = Vector2.RIGHT
export(int) var SPEED: int = 200


func _physics_process(delta):
	var movement = RIGHT.rotated(rotation) * SPEED * delta
	global_position += movement

func destroy():
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()


func _on_Bullet_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
	if body.is_in_group("Tilemap"):
		destroy()


func _on_Timer_timeout():
	queue_free()
