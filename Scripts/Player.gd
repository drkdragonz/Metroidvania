extends KinematicBody2D
 
export var jump_force = 300
export var _speed = 200
export var _gravity = 800
 
export var can_jump_start = 3
 
var can_jump = 2
 
var _velocity = Vector2.ZERO
var _floor = Vector2(0, -1)
onready var animated_sprite = $AnimatedSprite

 
var dashDirection = Vector2(1, 0)
var canDash = false
var dashing = false

var attacking = false
var can_shoot = true
const SHURIKEN = preload("res://Scenes/Shuriken.tscn")

export var Health = 5
var knockback = 700
var player_pos = null
var enemy_pos = null


enum {
	IDLE
	RUN
	AIR
	ATTACK
	SHOOT
	DEATH
	KNOCKBACK
}
 
var _state: int = IDLE
var previous_state = null
 
func _ready():
	can_jump = can_jump_start
	print(can_jump)
 
func _physics_process(delta):
	#print(_velocity)
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
	if Input.is_action_just_pressed("Shoot"):
		change_state(SHOOT)
	
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
		KNOCKBACK:
			player_pos = global_position
			#print(enemy_pos)
			#print(player_pos)
			_velocity = 0
			_velocity = (player_pos - enemy_pos).normalized() * knockback 
			#print(_velocity)
			#print("knockback")
			$HitBox/CollisionShape2D.disabled = true
			$AnimationPlayer.play("Flash")
			$Timer.start()
			change_state(IDLE)
		ATTACK:
			attacking = true
			if is_on_floor():
				_velocity.x = 0
			animated_sprite.play("Attack")
			$Sword/CollisionShape2D.disabled = false
			#then if the animation is finished and change the state back to idle
		SHOOT:
			pass
			var shuriken = SHURIKEN.instance()
			if sign($Position2D.position.x) == 1:
				shuriken.set_direction(1)
			else:
				shuriken.set_direction(-1)
			get_parent().add_child(shuriken)
			shuriken.position = $Position2D.global_position
			change_state(IDLE)
		DEATH:
			animated_sprite.play("Death")
			yield(get_tree().create_timer(1.2), "timeout")
			get_tree().reload_current_scene()
			

			
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
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
	if move_direction().x > 0:
		animated_sprite.flip_h = false
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
func _on_AnimatedSprite_animation_finished():
	if attacking == true:
		attacking = false
		$Sword/CollisionShape2D.disabled = true
		change_state(IDLE)

func _on_HitBox_area_entered(area):
	if area.is_in_group("Enemy"):
		enemy_pos = (area.get_parent()).get_global_position()
		#print("hit")
		Health -= 1 
		$TempUi/CanvasLayer/Label.text = str(Health)
		change_state(KNOCKBACK)
		if Health < 1:
			change_state(DEATH)
			$TempUi/CanvasLayer/Label.text = str("Dead")
	if area.is_in_group("Projectile"):
		#print("hit")
		Health -= 1
		$TempUi/CanvasLayer/Label.text = str(Health)
		$AnimationPlayer.play("Flash")
		$HitBox/CollisionShape2D.disabled = true
		$Timer.start()
		if Health < 1:
			$TempUi/CanvasLayer/Label.text = str("Dead")
			change_state(DEATH)


func _on_Timer_timeout():
	$HitBox/CollisionShape2D.disabled = false
