extends Area2D
var speed = 0


func _on_body_entered(body):
	if body.name == "Player":
		

		# Start spinning the player before boosting speed
		spin_player(body)

func spin_player(player):
	var tween = player.create_tween()
	tween.tween_property(player, "rotation_degrees", 360, 0.5)  # Rotate 360 degrees in 0.5 sec
	player.gravity = 0
	player.velocity.y = 0
	speed = player.current_speed
	player.current_speed = 0
	await tween.finished  # Wait for the spin to finish
	player.current_speed = speed
	player.velocity.y = -300
	await get_tree().create_timer(0.1).timeout
	player.gravity = 20
	speed = 0
	
	
	

	# After spinning, increase speed
	if player.current_speed < 1000:
		player.current_speed += 100
		if player.max_speed >= 1000:
			pass
		else:
			player.max_speed += 100
		await get_tree().create_timer(2).timeout
