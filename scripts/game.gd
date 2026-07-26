extends Node2D

var items_collected = 0
var goal_items = 3

@export var max_time: float = 300.0
@onready var current_time: float = max_time
@export var countdown_rate: float = 1.0 
@onready var game_timer: Timer = $CanvasLayer/GameTimer
@onready var countdown_label: Label = $CanvasLayer/CountdownLabel
@onready var real_clock_label: Label = $CanvasLayer/RealClockLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/TextureProgressBar.max_value = max_time
	$CanvasLayer/TextureProgressBar.value = max_time
	
	game_timer.wait_time = max_time
	game_timer.start()
	
	$CanvasLayer/Tracker/HBoxContainer/Bag.modulate.a = 0.25
	$CanvasLayer/Tracker/HBoxContainer/Biscuit.modulate.a = 0.25
	$CanvasLayer/Tracker/HBoxContainer/Key.modulate.a = 0.25
	$CanvasLayer/fade_transition/AnimationPlayer.play("fade_out")
	await $CanvasLayer/fade_transition/AnimationPlayer.animation_finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_time -= countdown_rate * delta
	current_time = clamp(current_time, 0.0, max_time)
	$CanvasLayer/TextureProgressBar.value = current_time
	
	if current_time <= 0:
		get_tree().reload_current_scene()
	
	if game_timer.time_left > 0:
		var seconds_passed: int = int(max_time - game_timer.time_left)
		
		var start_hour: int = 4
		var start_minute: int = 55
		
		var current_minute: int = start_minute + (seconds_passed / 60)
		var current_second: int = seconds_passed % 60
		var current_hour: int = start_hour
		
		if current_minute >= 60:
			current_hour += 1
			current_minute -= 60
			
		real_clock_label.text = "%d:%02d:%02d PM" % [current_hour, current_minute, current_second]
	else:
		real_clock_label.text = "5:00:00 PM"

func _on_biscuit_body_entered(body: Node2D) -> void:
	$Items/Biscuit.queue_free()
	items_collected += 1
	$CanvasLayer/Label.text = "Items Collected: " + (str(items_collected))
	$CanvasLayer/Tracker/HBoxContainer/Biscuit.modulate.a = 1.0


func _on_bag_body_entered(_body: Node2D) -> void:
	$Items/Bag.queue_free()
	items_collected += 1
	$CanvasLayer/Label.text = "Items Collected: " + (str(items_collected))
	$CanvasLayer/Tracker/HBoxContainer/Bag.modulate.a = 1.0


func _on_key_body_entered(_body: Node2D) -> void:
	$Items/Key.queue_free()
	items_collected += 1
	$CanvasLayer/Label.text = "Items Collected: " + (str(items_collected))
	$CanvasLayer/Tracker/HBoxContainer/Key.modulate.a = 1.0


func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "player": 
		if items_collected >= 3:
			print("All items collected! Game completed...")
			$CanvasLayer/fade_transition/AnimationPlayer.play("fade_in")
			await $CanvasLayer/fade_transition/AnimationPlayer.animation_finished
			get_tree().change_scene_to_file("res://scenes/thanks.tscn")
		else:
			print("The portal is locked! You only have " + str(items_collected) + "/3 items.")
			# Optional: Trigger an onscreen message or sound effect to alert the player


func _on_timer_timeout() -> void:
	countdown_label.text = "TIME'S UP!"
	get_tree().reload_current_scene()
