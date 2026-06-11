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

func _on_num_rrange_value_changed(value: float) -> void:
	$Gui/NumRangeInfo.text = "Zasięg Liczb od 0 do %d" % int(value)
	Global.max_gen_num = value

func _on_modes_item_selected(index: int) -> void:
	Global.mode = index

func _on_time_range_value_changed(value: float) -> void:
	$Gui/TimeInfo.text = "Czas na odpowiedz to %d sekund" % int(value)
	Global.reset_time = value
