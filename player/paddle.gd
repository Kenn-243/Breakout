extends CharacterBody2D


const SPEED = 1000.0

var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	velocity.x = direction * SPEED

	move_and_slide()

func start(pos):
	position = pos
	show()
