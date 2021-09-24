extends Area2D



func _on_Spike_body_entered(body):
	if body.is_in_group("Player"):
		$CollisionShape2D.disabled = true
		yield(get_tree().create_timer(2), "timeout")
		$CollisionShape2D.disabled = false


func _on_Spike_body_exited(body):
		$CollisionShape2D.disabled = false
