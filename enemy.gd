extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

var speed = 100
var direction = 1
var left_limit = 0.0
var right_limit = 0.0
var patrol_range = 50  # How far left/right the enemy should go from its starting point

func _ready():
	sprite.play("run")
	
	# Set patrol limits based on initial position
	left_limit = position.x - patrol_range
	right_limit = position.x + patrol_range

func _physics_process(delta: float) -> void:
	# Move the enemy back and forth
	velocity.x = speed * direction
	move_and_slide()

	# Flip sprite based on direction
	sprite.flip_h = direction < 0

	# Reverse direction when reaching limits
	if position.x > right_limit:
		direction = -1
	elif position.x < left_limit:
		direction = 1

	# Keep animation consistent
	if sprite.animation != "run":
		sprite.play("run")
