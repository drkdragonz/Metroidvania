extends Node2D


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func _ready():
	$Player/Camera2D.current = true

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		$Player/Camera2D.current = true


func _on_Area2D2_body_entered(body):
	if body.get_name() == "Player":
		$Player/Camera2D2.current = true
