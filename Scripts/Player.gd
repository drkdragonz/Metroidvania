extends KinematicBody2D
 
export var jump_force = 300
export var _speed = 200
export var _gravity = 800
 
export var can_jump_start = 3
 
var can_jump = 2
 
var _velocity = Vector2()
var _floor = Vector2(0, -1)
onready var animated_sprite = $AnimatedSprite
 
var dashDirection = Vector2(1, 0)
var canDash = false
var dashing = false

var attacking = false

export var Health = 3

enum {
	IDLE
	RUN
	AIR
	ATTACK
	STUNNED
	DEATH
}
 
var _state: int = IDLE
var previous_state = null
 
func _ready():
	can_jump = can_jump_start
	print(can_jump)
 
func _physics_process(delta):
	#print(_state)
	_velocity.x = move_direction().x * _speed
	_velocity.y += _gravity
	flip_sprite()
	
	
	if Input.is_action_just_pressed("up") and can_jump > 0:
		_velocity.y = -jump_force
		can_jump -= 1
		change_state(AIR)
	if Input.is_action_just_pressed("Attack"):
		change_state(ATTACK)
	
	match _state:
		IDLE:
			animated_sprite.play("Idle")
			if is_on_floor() and _velocity.x:
				change_state(RUN)
			if is_on_floor():
				can_jump = 2
		RUN:
			animated_sprite.play("Run")
			if is_on_floor() and not _velocity.x:
				change_state(IDLE)
		AIR:
			animated_sprite.play("Jump")
			if is_on_floor() and _velocity.y > 0:
				change_state(IDLE)
				can_jump = can_jump_start
		ATTACK:
			attacking = true
			if is_on_floor():
				_velocity.x = 0
			animated_sprite.play("Attack")
			$Sword/CollisionShape2D.disabled = false
			#then if the animation is finished and change the state back to idle
		DEATH:
			animated_sprite.play("Death")
			yield(get_tree().create_timer(0.5), "timeout")
			queue_free()
			

			
	_velocity = move_and_slide(_velocity, _floor)
 
 
func move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 0)
 
func change_state(target_state: int):
	_state == previous_state
	_state = target_state

func flip_sprite() -> void:
	var animated_sprite = $AnimatedSprite
	if move_direction().x < 0:
		animated_sprite.flip_h = true
	if move_direction().x > 0:
		animated_sprite.flip_h = false
		
func _on_AnimatedSprite_animation_finished():
	if attacking == true:
		attacking = false
		$Sword/CollisionShape2D.disabled = true
		change_state(IDLE)

func _on_HitBox_area_entered(area):
	if area.is_in_group("Enemy"):
		#print("hit")
		Health -= 1 
		$TempUi/CanvasLayer/Label.text = str(Health)
		if Health < 1:
			change_state(DEATH)
			$TempUi/CanvasLayer/Label.text = str("Dead")
	if area.is_in_group("Spike"):
		#print("hit")
		Health -= 3
		$TempUi/CanvasLayer/Label.text = str(Health)
		if Health < 1:
			$TempUi/CanvasLayer/Label.text = str("Dead")
			change_state(DEATH)
