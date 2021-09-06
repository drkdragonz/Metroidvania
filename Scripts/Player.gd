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
 
enum {
	IDLE
	RUN
	AIR
}
 
var _state: int = IDLE
var previous_state = null
 
func _ready():
	can_jump = can_jump_start
	print(can_jump)
 
func _physics_process(delta):
	print(_state)
	_velocity.x = move_direction().x * _speed
	_velocity.y += _gravity
	flip_sprite()
	
	
	if Input.is_action_just_pressed("up") and can_jump > 0:
		_velocity.y = -jump_force
		can_jump -= 1
		change_state(AIR)
	
	match _state:
		IDLE:
			animated_sprite.play("Idle")
			if is_on_floor() and _velocity.x:
				change_state(RUN)
			if is_on_floor():
				can_jump = 3
		RUN:
			animated_sprite.play("Run")
			if is_on_floor() and not _velocity.x:
				change_state(IDLE)
		AIR:
			animated_sprite.play("Jump")
			if is_on_floor() and _velocity.y > 0:
				change_state(IDLE)
				can_jump = can_jump_start
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
 
