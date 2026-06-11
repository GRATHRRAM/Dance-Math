extends Node2D

var Gravity = 20
var Turbulance = 10
var LifeTime = 5
var Speed = 10
var StartPosition = Vector2.ZERO
var rot = 0

var tmr = 0.5
var dir = 0

@export var sway_speed := 3.0
@export var sway_amount := 20.0 # degrees

var time := 0.0

func _ready() -> void:
	self.position = StartPosition
	rot = randf_range(-3,3)

func _process(delta: float) -> void:
	var Vec = Vector2(dir, Gravity)
	self.position += Vec * Speed * delta
	
	time += delta
	rotation_degrees = sin(time * sway_speed) * sway_amount
	
	if tmr > 0:
		dir = randf_range(-Turbulance, Turbulance)
		tmr = randf_range(0.7,1.7)
	
	LifeTime -= delta
	if LifeTime < 0:
		queue_free()
