extends Node2D


func _ready() -> void:
	$Gui/tabl.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_pressed("Right1"):
		$Gui/Lewa.rotation_degrees = 0
	if Input.is_action_pressed("Left1"):
		$Gui/Lewa.rotation_degrees = -180
	if Input.is_action_pressed("Up1"):
		$Gui/Lewa.rotation_degrees = -90
	if Input.is_action_pressed("Down1"):
		$Gui/Lewa.rotation_degrees = 90
	if Input.is_action_pressed("Right2"):
		$Gui/Prawa.rotation_degrees = 0
	if Input.is_action_pressed("Left2"):
		$Gui/Prawa.rotation_degrees = -180
	if Input.is_action_pressed("Up2"):
		$Gui/Prawa.rotation_degrees = -90
	if Input.is_action_pressed("Down2"):
		$Gui/Prawa.rotation_degrees = 90


func _on_tabl_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")
