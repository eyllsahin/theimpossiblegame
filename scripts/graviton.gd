# File: res://scripts/Graviton.gd
# Attach to the root CharacterBody2D of res://scenes/graviton.tscn

extends CharacterBody2D

var is_player_controlled: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

const SPEED: float = 250.0
const JUMP_VELOCITY: float = -400.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATES { IDLE, WALK, JUMP, PUNCH, KICK, SHOOT, BLOCK, HURT, DIE, VICTORY, TIMEOVER }
var state: STATES = STATES.IDLE
var previous_state: STATES = STATES.IDLE

# AI variables
var ai_timer: float = 0.0
var ai_action_delay: float = 1.2

# Health system
var max_health: float = 100.0
var current_health: float = 100.0
var is_dead: bool = false

# Combat variables
var attack_cooldown: float = 0.0
var hurt_timer: float = 0.0
var is_hurt: bool = false
var is_attacking: bool = false
var animation_locked: bool = false

# Hitboxes
var punch_hitbox: Area2D
var kick_hitbox: Area2D
var hurtbox: Area2D

func _ready() -> void:
	setup_hitboxes()
	sprite.play("idle")
	# Connect animation finished signal
	sprite.animation_finished.connect(_on_animation_finished)

func setup_hitboxes():
	# Create punch hitbox
	punch_hitbox = Area2D.new()
	punch_hitbox.name = "PunchHitbox"
	var punch_collision = CollisionShape2D.new()
	var punch_shape = RectangleShape2D.new()
	punch_shape.size = Vector2(120, 80)
	punch_collision.shape = punch_shape
	punch_hitbox.add_child(punch_collision)
	punch_hitbox.monitoring = false
	punch_hitbox.collision_layer = 2
	punch_hitbox.collision_mask = 4
	add_child(punch_hitbox)
	
	# Create kick hitbox
	kick_hitbox = Area2D.new()
	kick_hitbox.name = "KickHitbox"
	var kick_collision = CollisionShape2D.new()
	var kick_shape = RectangleShape2D.new()
	kick_shape.size = Vector2(140, 70)
	kick_collision.shape = kick_shape
	kick_hitbox.add_child(kick_collision)
	kick_hitbox.monitoring = false
	kick_hitbox.collision_layer = 2
	kick_hitbox.collision_mask = 4
	add_child(kick_hitbox)
	
	# Create hurtbox
	hurtbox = Area2D.new()
	hurtbox.name = "Hurtbox"
	var hurt_collision = CollisionShape2D.new()
	var hurt_shape = RectangleShape2D.new()
	hurt_shape.size = Vector2(100, 180)
	hurt_collision.shape = hurt_shape
	hurt_collision.position = Vector2(0, -90)
	hurtbox.add_child(hurt_collision)
	hurtbox.monitoring = true
	hurtbox.collision_layer = 4
	hurtbox.collision_mask = 2
	add_child(hurtbox)
	
	# Connect signals
	punch_hitbox.area_entered.connect(_on_punch_hit)
	kick_hitbox.area_entered.connect(_on_kick_hit)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	# Update timers
	if attack_cooldown > 0:
		attack_cooldown -= delta
	if hurt_timer > 0:
		hurt_timer -= delta
		if hurt_timer <= 0:
			is_hurt = false
			animation_locked = false
			if state == STATES.HURT:
				change_state(STATES.IDLE)
	
	# Update hitbox positions
	update_hitbox_positions()
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_player_controlled:
		_handle_input(delta)
	else:
		_ai_behavior(delta)
	
	move_and_slide()
	
	# Handle landing from jump
	if state == STATES.JUMP and is_on_floor() and velocity.y >= 0:
		animation_locked = false
		change_state(STATES.IDLE)

func change_state(new_state: STATES):
	if animation_locked and new_state != STATES.HURT and new_state != STATES.DIE:
		return
		
	previous_state = state
	state = new_state
	
	match state:
		STATES.IDLE:
			play_idle()
		STATES.WALK:
			play_walk()
		STATES.JUMP:
			play_jump()
		STATES.PUNCH:
			play_punch()
		STATES.KICK:
			play_kick()
		STATES.HURT:
			play_hurt()
		STATES.DIE:
			play_die()
		STATES.BLOCK:
			play_block()

func update_hitbox_positions():
	var facing_right = !sprite.flip_h
	
	if facing_right:
		punch_hitbox.position = Vector2(100, -80)
		kick_hitbox.position = Vector2(110, -40)
	else:
		punch_hitbox.position = Vector2(-100, -80)
		kick_hitbox.position = Vector2(-110, -40)

func _handle_input(delta: float) -> void:
	if is_hurt:
		return
		
	# Handle attacks - highest priority
	if attack_cooldown <= 0 and not animation_locked:
		if Input.is_action_just_pressed("attack_punch"):
			perform_punch()
			return
		elif Input.is_action_just_pressed("attack_kick"):
			perform_kick()
			return
	
	# Handle jump - can interrupt walk/idle
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not animation_locked:
		velocity.y = JUMP_VELOCITY
		animation_locked = true
		change_state(STATES.JUMP)
		return
	
	# Handle horizontal movement - only if not attacking or jumping
	if not is_attacking and not animation_locked:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			velocity.x = direction * SPEED
			sprite.flip_h = direction < 0
			if is_on_floor() and state != STATES.WALK:
				change_state(STATES.WALK)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor() and state != STATES.IDLE and state != STATES.JUMP:
				change_state(STATES.IDLE)

func _ai_behavior(delta: float) -> void:
	if is_hurt or animation_locked:
		return
		
	ai_timer += delta
	
	if ai_timer >= ai_action_delay:
		ai_timer = 0.0
		
		var random_action = randi() % 6
		match random_action:
			0: # Move left
				if not is_attacking:
					velocity.x = -SPEED * 0.4
					sprite.flip_h = true
					if is_on_floor() and state != STATES.WALK:
						change_state(STATES.WALK)
			1: # Move right
				if not is_attacking:
					velocity.x = SPEED * 0.4
					sprite.flip_h = false
					if is_on_floor() and state != STATES.WALK:
						change_state(STATES.WALK)
			2: # Jump
				if is_on_floor() and not is_attacking:
					velocity.y = JUMP_VELOCITY
					animation_locked = true
					change_state(STATES.JUMP)
			3: # Idle
				if not is_attacking:
					velocity.x = 0
					if is_on_floor() and state != STATES.IDLE:
						change_state(STATES.IDLE)
			4: # Punch
				if attack_cooldown <= 0:
					perform_punch()
			5: # Kick
				if attack_cooldown <= 0:
					perform_kick()

func perform_punch():
	if is_attacking or is_hurt or animation_locked:
		return
		
	print("Graviton performing punch!")
	is_attacking = true
	animation_locked = true
	velocity.x = 0
	attack_cooldown = 1.0
	change_state(STATES.PUNCH)
	
	# Enable hitbox during active frames
	get_tree().create_timer(0.15).timeout.connect(func(): 
		if state == STATES.PUNCH:
			punch_hitbox.monitoring = true
			print("Graviton punch hitbox enabled!")
	)
	get_tree().create_timer(0.35).timeout.connect(func(): 
		punch_hitbox.monitoring = false
		print("Graviton punch hitbox disabled!")
	)

func perform_kick():
	if is_attacking or is_hurt or animation_locked:
		return
		
	print("Graviton performing kick!")
	is_attacking = true
	animation_locked = true
	velocity.x = 0
	attack_cooldown = 1.5
	change_state(STATES.KICK)
	
	# Enable hitbox during active frames
	get_tree().create_timer(0.2).timeout.connect(func(): 
		if state == STATES.KICK:
			kick_hitbox.monitoring = true
			print("Graviton kick hitbox enabled!")
	)
	get_tree().create_timer(0.4).timeout.connect(func(): 
		kick_hitbox.monitoring = false
		print("Graviton kick hitbox disabled!")
	)

func _on_animation_finished():
	print("Graviton animation finished: ", sprite.animation)
	
	# Reset flags based on what animation finished
	match sprite.animation:
		"punch", "kick":
			is_attacking = false
			animation_locked = false
			if is_on_floor():
				change_state(STATES.IDLE)
		"jump":
			# Jump animation finished, but we might still be in air
			if is_on_floor():
				animation_locked = false
				change_state(STATES.IDLE)
		"hurt":
			is_hurt = false
			animation_locked = false
			change_state(STATES.IDLE)
		"die":
			# Stay dead
			pass

func _on_punch_hit(area: Area2D):
	if area.get_parent() != self and area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(5.0)
		print("Graviton punch hit target!")

func _on_kick_hit(area: Area2D):
	if area.get_parent() != self and area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(8.0)
		print("Graviton kick hit target!")

func take_damage(damage: float):
	if is_dead or is_hurt:
		return
		
	current_health -= damage
	print("Graviton health: ", current_health)
	
	if current_health <= 0:
		current_health = 0
		die()
	else:
		get_hurt()

func get_hurt():
	is_hurt = true
	is_attacking = false
	animation_locked = true
	hurt_timer = 0.8
	velocity.x = 0
	change_state(STATES.HURT)

func die():
	is_dead = true
	is_attacking = false
	animation_locked = true
	velocity.x = 0
	change_state(STATES.DIE)
	# Disable all hitboxes
	punch_hitbox.monitoring = false
	kick_hitbox.monitoring = false
	hurtbox.monitoring = false

# Helper function to check if animation exists
func has_animation(animation_name: String) -> bool:
	if sprite and sprite.sprite_frames:
		return sprite.sprite_frames.has_animation(animation_name)
	return false

# Animation helpers - only play if animation exists and is different from current
func play_block() -> void: 
	if has_animation("block") and sprite.animation != "block":
		sprite.play("block")

func play_die() -> void: 
	if has_animation("die") and sprite.animation != "die":
		sprite.play("die")

func play_hurt() -> void: 
	if has_animation("hurt") and sprite.animation != "hurt":
		sprite.play("hurt")

func play_idle() -> void: 
	if has_animation("idle") and sprite.animation != "idle":
		sprite.play("idle")

func play_jump() -> void: 
	if has_animation("jump") and sprite.animation != "jump":
		sprite.play("jump")

func play_ready_to_shoot() -> void: 
	if has_animation("readytoshoot") and sprite.animation != "readytoshoot":
		sprite.play("readytoshoot")

func play_kick() -> void: 
	if has_animation("kick") and sprite.animation != "kick":
		sprite.play("kick")

func play_punch() -> void: 
	if has_animation("punch") and sprite.animation != "punch":
		sprite.play("punch")

func play_time_over() -> void: 
	if has_animation("timeover") and sprite.animation != "timeover":
		sprite.play("timeover")

func play_walk() -> void: 
	if has_animation("walk") and sprite.animation != "walk":
		sprite.play("walk")
