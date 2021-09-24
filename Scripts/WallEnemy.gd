extends KinematicBody2D

export(PackedScene) var BULLET: PackedScene = null

onready var path_follow = get_parent()

var target: Node2D = null

var speed = 60
var move_direction = 0

onready var rayCast = $RayCast2D
onready var reloadTimer = $RayCast2D/ReloadTimer

func _ready():
	target = find_target()

func _physics_process(delta):
	MovementLoop(delta)
	if target != null:
		var angle_to_target: float = global_position.direction_to(target.global_position).angle()
		rayCast.global_rotation = angle_to_target
		
		if rayCast.is_colliding() and rayCast.get_collider().is_in_group("Player"):
			if reloadTimer.is_stopped():
				shoot()


func shoot():
	#print("Shoot")
	rayCast.enabled = false
	
	if BULLET:
		var bullet: Node2D = BULLET.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = rayCast.global_rotation
	
	reloadTimer.start()

func find_target():
	var new_target: Node2D = null
	
	if get_tree().has_group("Player"):
		new_target = get_tree().get_nodes_in_group("Player")[0]
	
	return new_target

func _on_ReloadTimer_timeout():
	rayCast.enabled = true
	find_target()
	
func MovementLoop(delta):
	#print("Found Path")
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	var pos = path_follow.get_global_position()
	move_direction = (pos.angle_to_point(prepos) / 3.14) * 180
	
	
func _on_HurtBox_area_entered(area):
	if area.is_in_group("Sword"):
		#print("Sword Enterd")
		queue_free()












