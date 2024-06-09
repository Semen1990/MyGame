extends Area2D



#Респаун монут
func _on_body_entered(body):
	if body.name == "Player":
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 35), 0.8)
		tween1.tween_property(self, "modulate:a", 0, 0.8)
		tween.tween_callback(queue_free)
		body.gold += 5
		
