extends CharacterBody2D

@export var max_speed = 500   # Maximum speed the player can reach
@export var acceleration = 15 # Rate of acceleration
@export var deceleration = 100  # Rate of deceleration when stopping
@export var gravity = 20
@export var jump_force = 300
@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
@onready var Jumps = 0

var current_speed = 0  # Tracks the current speed of the player

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		velocity.y = min(velocity.y, 1000)  # Clamp max fall speed
	else:
		# When touching the ground, reset jumps
		Jumps = 0

	# **Fixed Jumping**
	if Input.is_action_just_pressed("jump") and Jumps < 2:
		velocity.y = -jump_force
		animated_sprite.play("lestweforget")
		Jumps += 1  # Correct way to increment Jumps

	var horizontal_direction = Input.get_axis("move_left", "move_right")
	
	# **Increase speed gradually when moving**
	if horizontal_direction != 0:
		current_speed = min(current_speed + acceleration * delta, max_speed)
	else:
		# **Decelerate when no input is given**
		current_speed = max(current_speed - deceleration * delta, 0)

	velocity.x = current_speed * horizontal_direction

	# **Collision check**
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider and collider.name == "sign":  # Check if the object's name is "sign"
			print("✅ Collided with a sign!")

	move_and_slide()
	handle_movement_animation(horizontal_direction)

func handle_movement_animation(dir):
	if dir == 0:
		animated_sprite.play("Idle")
	else:
		animated_sprite.play("walking")
		animated_sprite.flip_h = dir < 0  # Flip sprite when moving left

func launch_upwards(force: float):
	velocity.y = force
