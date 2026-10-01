extends CharacterBody2D

const SPEED := 500
const MAX_BOUNCE_DEGREE = 60.0

var score := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(1, -1).normalized() * SPEED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		var hit = collision.get_collider()
		if hit.is_in_group("paddle"):
			bounce_off_paddle(hit)
		else:
			velocity = velocity.bounce(collision.get_normal())
			if hit.is_in_group("bricks"):
				score += 1
				hit.queue_free()
				
func bounce_off_paddle(paddle: Node2D) -> void:
	var half_width := 50.0
	var offset := (global_position.x - paddle.global_position.x) / half_width
	offset = clamp(offset, -1.0, 1.0)
	var angle := offset * deg_to_rad(MAX_BOUNCE_DEGREE)
	velocity = Vector2.UP.rotated(angle) * SPEED

func start(pos):
	position = pos
	show()
