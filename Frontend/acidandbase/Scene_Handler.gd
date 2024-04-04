extends Node



func _ready():
	load_main_menu()
	$MusicAudio.play()


func load_main_menu():
	get_node("MainMenu/MarginContainer/VBoxContainer/PlayButton").connect("pressed", Callable(self, "_on_play_button_pressed"))
	get_node("MainMenu/MarginContainer/VBoxContainer/ExitButton").connect("pressed", Callable(self, "_on_exit_button_pressed"))


func _on_play_button_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://acidandbase/Scenes/MainScenes/game_scene.tscn").instantiate()
	game_scene.connect("game_finished", Callable(self, 'unload_game'))
	add_child(game_scene)


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/gameLauncher.tscn")


func unload_game(_result):
	get_tree().change_scene_to_file("res://acidandbase/Scene_Handler.tscn")
