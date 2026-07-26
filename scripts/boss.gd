extends CharacterBody2D

const tile_size: Vector2 = Vector2(16, 16)
var enemy_tween: Tween
var player: CharacterBody2D = null

@export var move_duration: float = 3.0
@export var step_delay: float = 3.0 
var is_waiting: bool = false

func _ready() -> void:
	global_position.x = (floor(global_position.x / 16.0) * 16.0) + 8.0
	global_position.y = (floor(global_position.y / 16.0) * 16.0) + 8.0
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	if player == null:
		return
		
	if !enemy_tween or !enemy_tween.is_running():
		var direction_to_player = (player.global_position - global_position).normalized()
		
		if abs(direction_to_player.x) > abs(direction_to_player.y):
			if direction_to_player.x > 0 and not $right.is_colliding(): _move(Vector2(1, 0))
			elif direction_to_player.x < 0 and not $left.is_colliding(): _move(Vector2(-1,0))
			elif direction_to_player.y > 0 and not $down.is_colliding(): _move(Vector2(0, 1))
			elif direction_to_player.y < 0 and not $up.is_colliding(): _move(Vector2(0, -1))
		else:
			if direction_to_player.y > 0 and not $down.is_colliding(): _move(Vector2(0, 1))
			elif direction_to_player.y < 0 and not $up.is_colliding(): _move(Vector2(0, -1))
			elif direction_to_player.x > 0 and not $right.is_colliding(): _move(Vector2(1, 0))
			elif direction_to_player.x < 0 and not $left.is_colliding(): _move(Vector2(-1, 0))

func _move(dir: Vector2):
	var target_position = global_position + (dir * tile_size)
	if enemy_tween:
		enemy_tween.kill()
	
	enemy_tween = create_tween()
	enemy_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	enemy_tween.tween_property(self, "global_position", target_position, 0.22).set_trans(Tween.TRANS_LINEAR)




func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player caught! Reloading level...")
		
		get_tree().reload_current_scene()
