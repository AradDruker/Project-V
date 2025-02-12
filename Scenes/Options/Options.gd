extends Control

var muteMusic_state
var muteSFX_state
var save_path = "user://data.save"
var highScore
var coin_total
var skin_1; var skin_2;
var skin_1_use; var skin_2_use;


func _ready():
	load_file()



func _process(_delta):
	if muteMusic_state == 1:
		$Menu/CenterRow/Buttons/MuteMusic.pressed = true
	else:
		$Menu/CenterRow/Buttons/MuteMusic.pressed = false
	
	if muteSFX_state == 1:
		$Menu/CenterRow/Buttons/MuteSFX.pressed = true
	else:
		$Menu/CenterRow/Buttons/MuteSFX.pressed = false


func _on_Back_pressed():
	Music.get_node("ButtonPress").play()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")




func _on_MuteMusic_pressed():
	Music.get_node("ButtonPress").play()
	if muteMusic_state == 1:
		AudioServer.set_bus_mute(2, not AudioServer.is_bus_mute(2))
		muteMusic_state = 0
		save(muteMusic_state)
	else:
		AudioServer.set_bus_mute(2, not AudioServer.is_bus_mute(2))
		muteMusic_state = 1
		save(muteMusic_state)




func _on_MuteSFX_pressed():
	Music.get_node("ButtonPress").play()
	if muteSFX_state == 1:
		AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))
		muteSFX_state = 0
		save(muteSFX_state)
	else:
		AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))
		muteSFX_state = 1
		save(muteSFX_state)



func load_file():
	var file = File.new()
	if file.file_exists(save_path):
		file.open_encrypted_with_pass(save_path, File.READ, "Porfpo12")
		highScore = file.get_var()
		muteMusic_state = file.get_var()
		muteSFX_state = file.get_var()
		coin_total = file.get_var()
		skin_1 = file.get_var()
		skin_1_use = file.get_var()
		skin_2 = file.get_var()
		skin_2_use = file.get_var()
		file.close()


func save(_shop):
	var file = File.new()
	file.open_encrypted_with_pass(save_path, File.WRITE, "Porfpo12")
	file.store_var(highScore)
	file.store_var(muteMusic_state)
	file.store_var(muteSFX_state)
	file.store_var(coin_total)
	file.store_var(skin_1)
	file.store_var(skin_1_use)
	file.store_var(skin_2)
	file.store_var(skin_2_use)
	file.close()
