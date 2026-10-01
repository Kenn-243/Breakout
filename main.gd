extends Node

@export var brick_scene: PackedScene

@onready var timer: Timer = $SpawnTimer
@export var brick_size := Vector2(100, 30)
@export var gap := 4.0
@onready var spawn_path: Path2D = $BrickSpawn

@onready var spawn_location: PathFollow2D = $BrickSpawn/BrickSpawnLocation
@onready var spawn_timer: Timer = $SpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func new_game():
	$Paddle.start($PaddlePosition.position)
	$Ball.start($BallPosition.position)
	spawn_timer.start()
	spawn_row()


func _on_ball_game_over_body_entered(body: Node2D) -> void:
	if body == $Ball:
		game_over()


func _on_brick_game_over_body_entered(body: Node2D) -> void:
	if body == $Brick:
		game_over()


func game_over():
	$GameOver.visible = true
	spawn_timer.stop()
	$Ball.queue_free()


func _on_spawn_timer_timeout() -> void:
	for brick in get_tree().get_nodes_in_group("bricks"):
		brick.position.y += brick_size.y + gap
	spawn_row()
	
func spawn_row() -> void:
	var length := spawn_path.curve.get_baked_length()
	var step := brick_size.x + gap
	var count := int((length + gap) / step)
	var start := (length - (count * step - gap)) / 2.0 + brick_size.x / 2.0

	for i in count:
		spawn_location.progress = start + i * step
		var brick = brick_scene.instantiate()
		brick.global_position = spawn_location.global_position
		brick.add_to_group("bricks")
		add_child(brick)
