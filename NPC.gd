extends Area2D

var Dialog = preload("res://DialogBox.tscn")
var active = false

func _ready():
	connect("body_entered", self, "_on_NPC_body_entered")
	connect("body_exited", self, "_on_NPC_body_exited")

func _process(delta):
	$QuestionMark.visible = active

func _input(event):
	if Input.is_action_just_pressed("ui_accept") and active == true:
		var DIALOG = Dialog.instance()
		get_parent().add_child(DIALOG)
		$CollisionShape2D.disabled = true
		$Timer.start()

func _on_NPC_body_entered(body):
	if body.name == "Player":
		active = true
		
	


func _on_NPC_body_exited(body):
	if body.name == "Player":
		active = false


func _on_Timer_timeout():
	$CollisionShape2D.disabled = false
