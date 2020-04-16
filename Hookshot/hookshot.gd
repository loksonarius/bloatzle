extends Node2D

signal hooked
signal maxed
signal unmaxed
signal released

const SPEED = 50
const MAX_SHOOT_LENGTH = 400
const MAX_ROPE_LENGTH = 250

onready var Hook = $Hook
onready var Rope = $Rope

var snaps = false
var taught = false
var direction = Vector2.ZERO
var tip = Vector2.ZERO
var flying = false
var hooked = false

func tip_angle():
	return position.angle_to_point(to_local(tip)) - PI / 2.0;

func shoot(dir):
	direction = dir.normalized()
	flying = true
	tip = global_position
	Hook.rotation = direction.angle() + PI / 2.0

func attach(target):
	hooked = true
	flying = false
	emit_signal("hooked", target)

func release():
	hooked = false
	flying = false
	taught = false
	emit_signal("released")

func maxed():
	taught = true
	emit_signal("maxed")
	if snaps:
		release()

func unmaxed():
	taught = false
	emit_signal("unmaxed")

func _process(_delta):
	self.visible = flying || hooked
	if !self.visible:
		return
	else:
		Rope.rotation = tip_angle()
		Rope.position = Hook.position * 0.5
		Rope.region_rect.size.y = Hook.position.length() * 2
		
	var rope_len = Hook.position.length()
	if flying && rope_len > MAX_SHOOT_LENGTH:
		release()
		
	if hooked:
		if !taught:
			if rope_len >= MAX_ROPE_LENGTH:
				maxed()
		else:
			if rope_len < MAX_ROPE_LENGTH:
				unmaxed()
	elif !hooked && taught:
		unmaxed()
		

func _physics_process(_delta):
	Hook.global_position = tip
	if flying && Hook.move_and_collide(direction * SPEED):
		attach(tip)
		
	tip = Hook.global_position
