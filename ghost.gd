extends CharacterBody2D

const SPEED = 50.0

var Directions: Dictionary
var currentDirection: String = "right"
var onCollisionDirection: String = ""
var nextDirection: String = ""

@export_enum("red", "pink", "blue", "yellow") var color: String = "red"

func _ready():
	$AnimatedSprite2D.animation = color + "Right"
	Directions = {
		"": false,
		"up": {
			"vector": Vector2(0, -1),
			"rays": [$to_up_left, $to_up_right, $to_up],
			"orthogonal": ["left", "right"],
			"reverse": "down",
			"animation": "Up",
			"flip_h": false
		},
		"down":{
			"vector": Vector2(0, 1),
			"rays": [$to_down_left, $to_down_right, $to_down],
			"orthogonal": ["left", "right"],
			"reverse": "up",
			"animation": "Down",
			"flip_h": false
		},
		"left":{
			"vector": Vector2(-1, 0),
			"rays": [$to_left_up, $to_left_down, $to_left],
			"orthogonal": ["up", "down"],
			"reverse": "right",
			"animation": "Right",
			"flip_h": true
		},
		"right":{
			"vector": Vector2(1, 0),
			"rays": [$to_right_up, $to_right_down, $to_right],
			"orthogonal": ["up", "down"],
			"reverse": "left",
			"animation": "Right",
			"flip_h": false
		}
	}
	
	currentDirection = "right"

func collisionAt(dir):
	var direction =  Directions[dir]
	
	if !direction:
		return false
		
	var rays = direction.rays
	for ray in rays:
		if ray.is_colliding():
			return true

func lookAt(dir):
	var newDirection = Directions[dir]
	
	if !newDirection:
		return
	$AnimatedSprite2D.play(color + newDirection.animation)
	$AnimatedSprite2D.flip_h = newDirection.flip_h
	
func takeDirection(dir, nowOrNext = false):
	var newDirection = Directions[dir]

	if !newDirection:
		return

	if collisionAt(dir):

		if nowOrNext:
			lookAt(dir)
			nextDirection = dir
		return false
	
	lookAt(dir)
	nextDirection = ""
	onCollisionDirection = dir
	currentDirection = dir
	return true

func _input(event):
	if event.is_action_pressed("ui_left"):
		takeDirection("left", true)
	elif event.is_action_pressed("ui_right"):
		takeDirection("right", true)
	elif event.is_action_pressed("ui_down"):
		takeDirection("down", true)
	elif event.is_action_pressed("ui_up"):
		takeDirection("up", true)

func _physics_process(_delta):
	if position.x < 0:
		position.x = 214
	if position.x > 214:
		position.x = 0
		

	var direction = Directions[currentDirection]

	if (!direction):
		return

	
	if (nextDirection && !collisionAt(nextDirection)):
		takeDirection(nextDirection)
	
	velocity.x = direction.vector.x * SPEED
	velocity.y = direction.vector.y * SPEED

	var collision = move_and_slide()
	print(collision)
	if (collision):
		if takeDirection(nextDirection):
			return
		if takeDirection(onCollisionDirection):
			return

		direction.orthogonal.shuffle()
		for key in direction.orthogonal:
			if takeDirection(key):
				return
		takeDirection(direction.reverse)


