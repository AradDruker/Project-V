extends KinematicBody2D

export (PackedScene) var World



var velocity = Vector2(10.0,10.0)
const MAX_SPEED = 12
const ACCELERATION = 90
const FRICTION_0 = 55
const FRICTION_1 = 50
const FRICTION_2 = 45
const FRICTION_3 = 40
onready var MOVE = true

signal game_over
signal coin_collected

func _ready():
	position = Vector2(640.0, 360.0)

func _physics_process(delta):
	if MOVE:
		# Input Collection - Player follows pointer.
		var input_vector = Vector2(position.x, position.y)
		var mouse_pos =  get_viewport().get_mouse_position()
		input_vector = input_vector.direction_to(mouse_pos)


		# Player movement and head point
		if input_vector != Vector2.ZERO:
			velocity += input_vector * ACCELERATION * delta
			velocity = velocity.clamped(MAX_SPEED)
			var ang = atan2(velocity.x, velocity.y)
			$PlayerSprite.rotation = PI - ang
	#
		#Player stops
		#else:
		#	velocity -= velocity * FRICTION * delta
		
		# Player slow to stop
		var dist = pow(pow(position.x - mouse_pos.x, 2) + pow(position.y - mouse_pos.y, 2), 0.5)
		if dist >= 240:
			velocity += input_vector * ACCELERATION * delta
		elif dist < 240 and dist >= 200:
			velocity = velocity * FRICTION_0 * delta
		elif dist < 200 and dist >= 160:
			velocity = velocity * FRICTION_1 * delta
		elif dist < 160 and dist >= 120:
			velocity = velocity * FRICTION_2 * delta
		elif dist < 120 and dist >= 80:
			velocity = velocity * FRICTION_3 * delta
		elif dist < 80:
			velocity = Vector2.ZERO

		
		# Bumps player if hits wall
		var collision = move_and_collide(velocity)
		if collision:
			var collided_shape = collision.get_collider_shape()
			if collided_shape == null:
				Music.get_node("BorderBump").play()
				velocity = velocity.bounce(collision.normal) * 1.5
				MOVE = false
			else:
				if "Coin" in collision.collider.name:
					emit_signal("coin_collected")
					Music.get_node("CoinPick").play()
					var object_id = collision.collider_id
					instance_from_id(object_id).queue_free()
				else:
					emit_signal("game_over")
	else:
		velocity = velocity * FRICTION_0 * delta
		var ang = atan2(velocity.x, velocity.y)
		$PlayerSprite.rotation = PI - ang
		var collision = move_and_collide(velocity)
		if velocity.length() < 14:
			MOVE = true
		if collision:
			var collided_shape = collision.get_collider_shape()
			if collided_shape == null:
				Music.get_node("BorderBump").play()
				velocity = velocity.bounce(collision.normal) * 1.5
				velocity = velocity.clamped(MAX_SPEED)
				MOVE = false
			else:
				if "Coin" in collision.collider.name:
					emit_signal("coin_collected")
					Music.get_node("CoinPick").play()
					var object_id = collision.collider_id
					instance_from_id(object_id).queue_free()
				else:
					emit_signal("game_over")
