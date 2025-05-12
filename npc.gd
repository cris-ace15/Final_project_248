extends AnimatedSprite2D

@onready var Saveme = $Saveme
@onready var talk_zone = $Area2D

func _ready():
	play("Idle")
	Saveme.visible = false
	talk_zone.body_entered.connect(_on_talk_zone_body_entered)
	talk_zone.body_exited.connect(_on_talk_zone_body_exited)

func _on_talk_zone_body_entered(body):
	if body.is_in_group("player"):
		Saveme.visible = true

func _on_talk_zone_body_exited(body):
	if body.is_in_group("player"):
		Saveme.visible = false
