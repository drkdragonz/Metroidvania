extends KinematicBody2D

var is_moving_left = true

var gravity =  100
var velocity = Vector2(0, 0)
var speed = 70

var _state = PATROLLING

var attacking = false

enum{
	PATROLLING
	ATTACKING
	DEATH
}


func _process(_delta):
	#print(_state)
	match _state:
		PATROLLING:
			$AnimatedSprite.play("Run")
			move_character()
			detect_turn_around()
			$AttackBox/CollisionShape2D.disabled = true
		ATTACKING:
			if attacking == true:
				yield(get_tree().create_timer(0.2), "timeout")
				$AttackBox/CollisionShape2D.disabled = false
				$AnimatedSprite.play("Attack")
				yield(get_tree().create_timer(0.5), "timeout")
				$AttackBox/CollisionShape2D.disabled = true
				change_state(PATROLLING)
				attacking = false
		DEATH:
			queue_free()
func move_character():
	velocity.x = -speed if is_moving_left else speed
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func detect_turn_around():
	if not $RayCast2D.is_colliding() or $RayCast2D2.is_colliding() and is_on_floor():
		is_moving_left = !is_moving_left
		scale.x = -scale.x


func change_state(target_state: int):
	_state = target_state

func _on_Area2D_body_entered(body):
	attacking = true
	if body.get_name() == "Player":
		change_state(ATTACKING)
		



func _on_HurtBox_area_entered(area):
	if area.is_in_group("Sword"):
		change_state(DEATH)
