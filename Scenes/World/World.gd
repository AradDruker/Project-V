extends Node

export (PackedScene) var Enemy

var score = 0

func _ready():
	randomize()
# warning-ignore:return_value_discarded
	$HUD.connect("ResetGame", self,"reset_game")
	$GameOverScreen.hide()

func calc_position():
	# Get the number of slice to slice the screen
	# Exmaple: Input 3 returns a random place within the 1/3 to 2/3 of the border
	# Generates a random position within 1/3 to 2/3 of the screen
	randomize()
	var size = get_viewport().size
	var x_pos = randi() % int(size.x)
	var y_pos = randi() % int(size.y)
	x_pos = clamp(x_pos, 100, size.x - 100)
	y_pos = clamp(y_pos, 100, size.y - 100)
	
	return [x_pos, y_pos]

func _physics_process(delta):
	var enemies = $Enemies.get_children()
	
	#Increse score every second
	score += delta * 30
	#Score UI
	$HUD/ScoreBox/HBoxContainer/Score.text = str(int(score))
	
	for en in enemies:
		if en:
			en.player_details($PlayerKinematicBody2D.position)
			
func _process(_delta):
	
	# Lets you exit the game with the escape key - Mainly for debugging comfort
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

#First spawn before the spawn intervals.
func _on_EnemySpawnInstant_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randf_range(4,5)
	for _i in my_random_number:
		var enemy = Enemy.instance()
		enemy.connect("exploded", self, "_add_score" )
		enemy.connect("game_over", self, "_game_over")
		var enemy_pos = calc_position()
		enemy.position.x = enemy_pos[0]
		enemy.position.y = enemy_pos[1]
		$Enemies.add_child(enemy)
		
		
func _on_EnemySpawn_timeout():
	for _i in range(randi() % 5 + 3):
		var enemy = Enemy.instance()
		enemy.connect("exploded", self, "_add_score" )
		var enemy_position = calc_position()
		enemy.position.x = enemy_position[0]
		enemy.position.y = enemy_position[1]
		$Enemies.add_child(enemy)
		
func reset_game():
	# Reset the game method
	# Need to reset the score
	
	$EnemySpawn.stop()
	$EnemySpawnInstant.stop()
	$PlayerKinematicBody2D.position = Vector2(640.0, 360.0)
	var enemies = $Enemies.get_children()
	score = 0
	for enemy in enemies:
		enemy.queue_free()
	
	###
	$EnemySpawn.start()
	$EnemySpawnInstant.start()

func _add_score():
	score += 100

func _game_over():
	pass
