extends CharacterBody2D

const SPEED = 200
const JUMP_VELOCITY = -400
const GRAVITY = 900

var is_attacking = false

# Health variables
var max_hp = 100
var hp = 100

@onready var attack_area : Area2D = $DealDamage  # Attack area reference
@onready var damage_area : Area2D = $TakeDamage  # Damage-taking area reference

func _ready():
	add_to_group("player")
	$AnimatedSprite2D.play("Idle")
	update_hud()
	attack_area.monitoring = false  # Make sure attack area is inactive initially

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	var input_direction = 0

	# Handle attack input
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("attack")
		print("Attack started")
		attack_area.monitoring = true  # Activate attack area

	# Check if attack animation reached last frame
	if is_attacking:
		var last_frame = $AnimatedSprite2D.sprite_frames.get_frame_count("attack") - 1
		if $AnimatedSprite2D.frame == last_frame:
			is_attacking = false
			print("Attack animation finished (frame reached)")
			# Transition after attack
			attack_area.monitoring = false  # Deactivate attack area

			if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
				$AnimatedSprite2D.play("run")
			else:
				$AnimatedSprite2D.play("Idle")

	# Handle movement if not attacking
	if not is_attacking:
		if Input.is_action_pressed("move_right"):
			input_direction += 1
			$AnimatedSprite2D.scale.x = 1
			if is_on_floor() and $AnimatedSprite2D.animation != "run":
				$AnimatedSprite2D.play("run")
		elif Input.is_action_pressed("move_left"):
			input_direction -= 1
			$AnimatedSprite2D.scale.x = -1
			if is_on_floor() and $AnimatedSprite2D.animation != "run":
				$AnimatedSprite2D.play("run")
		else:
			if is_on_floor() and $AnimatedSprite2D.animation != "Idle":
				$AnimatedSprite2D.play("Idle")

		velocity.x = input_direction * SPEED

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("jump")

	move_and_slide()

func take_damage(amount):
	hp -= amount
	if hp < 0:
		hp = 0
	update_hud()
	print("Player took damage! HP:", hp)

func heal(amount):
	hp += amount
	if hp > max_hp:
		hp = max_hp
	update_hud()
	print("Player healed! HP:", hp)

func update_hud():
	var hud = get_tree().root.get_node("Main/HUD")  # adjust "Main" to your scene root name
	var health_bar = hud.get_node("HPBar")
	var health_num = hud.get_node("HPNumber")

	# Position health bar at top-left corner (with a little padding)
	health_bar.position = Vector2(10, 10)  # Adjust the 10, 10 as needed for padding
	health_num.position = Vector2(10, 50)

	# Update the health bar value
	health_bar.value = hp

func _on_attack_area_body_entered(body):
	if is_attacking and body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(20)
			print("Enemy took damage!")
