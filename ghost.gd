extends CharacterBody2D


const SPEED = 300.0

var lastDirection = Vector2(0,0)
var nextDirection = Vector2(0,0)

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _input(event):
	
	if event.is_action("ui_left"):
		lastDirection = Vector2(-1,0)
	elif event.is_action("ui_right"):
		lastDirection = Vector2(1, 0)
	elif event.is_action("ui_down"):
		lastDirection = Vector2(0,1)
	elif event.is_action("ui_up"):
		lastDirection = Vector2(0, -1)

func _physics_process(delta):
	velocity.x = lastDirection.x * SPEED
	velocity.y = lastDirection.y * SPEED

	move_and_slide()
