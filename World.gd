extends Node2D

onready var PlayerCam = $Player/PlayerCam

func _ready():
	PlayerCam.current = true
