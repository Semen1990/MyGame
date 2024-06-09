extends CharacterBody2D
#
#const SPEED = 300.0
#const SLIDE_SPEED = 500.0
#const ATTACK_DURATION = 0.5  # Длительность атаки в секундах
#const SLIDE_DURATION = 0.3  # Длительность скольжения в секундах
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#@onready var anim = $AnimatedSprite2D
#@onready var animPlayer = $AnimationPlayer
#
#var health = 100
#var alive = true
#var gold = 0
#var is_attacking = false
#var attack_timer = 0.0
#var is_blocking = false
#var is_sliding = false
#var slide_timer = 0.0
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle attack.
	#if Input.is_action_just_pressed("attack") and is_on_floor() and not is_attacking and not is_blocking and not is_sliding:
		#is_attacking = true
		#attack_timer = ATTACK_DURATION
		#animPlayer.play("attack")
		#velocity.x = 0  # Останавливаем движение при атаке
#
	## Update attack timer
	#if is_attacking:
		#attack_timer -= delta
		#if attack_timer <= -0.1:
			#is_attacking = false
#
	## Handle block.
	#if Input.is_action_pressed("block") and is_on_floor() and not is_attacking and not is_sliding:
		#is_blocking = true
		#anim.play("block")
		#velocity.x = 0  # Останавливаем движение при блоке
	#else:
		#is_blocking = false
#
	## Handle slide.
	#if Input.is_action_just_pressed("slide") and is_on_floor() and not is_attacking and not is_blocking and not is_sliding:
		#is_sliding = true
		#slide_timer = SLIDE_DURATION
		#animPlayer.play("slide")
		#velocity.x = SLIDE_SPEED * (0.4 if $AnimatedSprite2D.flip_h == false else -0.4)  # Направление скольжения
#
	## Update slide timer
	#if is_sliding:
		#slide_timer -= delta
		#if slide_timer <= -0.3:
			#is_sliding = false
			#velocity.x = 0  # Останавливаем скольжение
#
	## Handle movement only if not attacking, blocking, or sliding
	#if not is_attacking and not is_blocking and not is_sliding:
		#var direction = Input.get_axis("left", "right")
		#velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)
#
		## Play appropriate animation
		#if is_on_floor():
			#if direction:
				#anim.play("Run")
			#else:
				#anim.play("Idle")
		#else:
			#anim.play("Jump" if velocity.y < 0 else "Fall")
#
		## Flip sprite based on direction
		#if direction != 0:
			#$AnimatedSprite2D.flip_h = direction < 0
#
	## Check health
	#if health <= 0:
		#queue_free()
		#get_tree().change_scene_to_file("res://menu.tscn")
#
	## Move the character
	#move_and_slide()


const SPEED = 300.0
const SLIDE_SPEED = 500.0
const ATTACK_DURATION = 0.7  # Длительность атаки в секундах
const SLIDE_DURATION = 0.5  # Длительность скольжения в секундах
const SLIDE_COOLDOWN = 1.0  # Время перезарядки между скольжениями

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer

var health = 100
var alive = true
var gold = 0
var is_attacking = false
var attack_timer = 0.0
var is_blocking = false
var is_sliding = false
var slide_timer = 0.0
var slide_cooldown_timer = 0.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle attack.
	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_attacking and not is_blocking and not is_sliding:
		is_attacking = true
		attack_timer = ATTACK_DURATION
		animPlayer.play("attack")
		velocity.x = 0  # Останавливаем движение при атаке

	# Update attack timer
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false

	# Handle block.
	if Input.is_action_pressed("block") and is_on_floor() and not is_attacking and not is_sliding:
		is_blocking = true
		anim.play("block")
		velocity.x = 0  # Останавливаем движение при блоке
	else:
		is_blocking = false

	# Handle slide.
	if Input.is_action_just_pressed("slide") and is_on_floor() and not is_attacking and not is_blocking and not is_sliding and slide_cooldown_timer <= 0:
		is_sliding = true
		slide_timer = SLIDE_DURATION
		animPlayer.play("slide")
		velocity.x = SLIDE_SPEED * (0.4 if $AnimatedSprite2D.flip_h == false else -0.4)  # Направление скольжения
		slide_cooldown_timer = SLIDE_COOLDOWN

	# Update slide timer and handle repeated sliding input
	if is_sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			is_sliding = false
			velocity.x = 0  # Останавливаем скольжение

	# Update slide cooldown timer
	if slide_cooldown_timer > 0:
		slide_cooldown_timer = max(0, slide_cooldown_timer - delta)

	# Handle movement only if not attacking, blocking, or sliding
	if not is_attacking and not is_blocking and not is_sliding:
		var direction = Input.get_axis("left", "right")
		velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)

		# Play appropriate animation
		if is_on_floor():
			if direction:
				anim.play("Run")
			else:
				anim.play("Idle")
		else:
			anim.play("Jump" if velocity.y < 0 else "Fall")

		# Flip sprite based on direction
		if direction != 0:
			$AnimatedSprite2D.flip_h = direction < 0

	# Check health
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")

	# Move the character
	move_and_slide()
