tool
extends StaticBody2D

enum RockType {
	small,
	medium,
	large,
}

export(RockType) var Type = RockType.medium setget set_type

onready var Sprite = $Sprite
onready var SmallCollision = $SmallCollision
onready var MediumCollision = $MediumCollision
onready var LargeCollision = $LargeCollision

onready var SmallSprite = load("res://Rock/small-rock.png")
onready var MediumSprite = load("res://Rock/medium-rock.png")
onready var LargeSprite = load("res://Rock/large-rock.png")

var ready = false

func _ready():
	ready = true
	update_resources()
	
func set_type(value):
	Type = value
	if ready:
		update_resources()
	
func update_resources():
	match Type:
		RockType.small:
			Sprite.texture = SmallSprite
			SmallCollision.disabled = false
		RockType.medium:
			Sprite.texture = MediumSprite
			MediumCollision.disabled = false
		RockType.large:
			Sprite.texture = LargeSprite
			LargeCollision.disabled = false
