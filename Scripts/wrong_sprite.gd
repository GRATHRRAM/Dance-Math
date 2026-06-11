extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("new_animation")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
