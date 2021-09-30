extends Area2D

var speed = 450
var velocity = Vector2()
var direction = 1



func set_direction(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true

func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)


func _on_Timer_timeout():
	queue_free()


func _on_Area2D_area_entered(area):
	#print("hi")
	speed = 0
	$AnimationPlayer.play("degrage")
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
	

func _on_Area2D_body_entered(body):
	#print("hi")
	speed = 0
	$AnimationPlayer.play("degrage")
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
	
