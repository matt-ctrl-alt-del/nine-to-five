extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/fade_transition/AnimationPlayer.play("fade_out")
	await $CanvasLayer/fade_transition/AnimationPlayer.animation_finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_play_pressed() -> void:
	$CanvasLayer/fade_transition/AnimationPlayer.play("fade_in")
	await $CanvasLayer/fade_transition/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_pressed() -> void:
	$CanvasLayer/fade_transition/AnimationPlayer.play("fade_in")
	await $CanvasLayer/fade_transition/AnimationPlayer.animation_finished
	get_tree().quit()
