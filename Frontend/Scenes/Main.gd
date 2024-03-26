extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = false
	$ColorRect2.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_signup_switch_btn_pressed():
	#make signup vissble and login invisible
	$ColorRect2.visible = false
	$ColorRect.visible = true
	pass # Replace with function body.
	
func _on_login_switch_btn_pressed():
	#make login vissble and sign up invisible
	$ColorRect.visible = false
	$ColorRect2.visible = true
	pass # Replace with function body.


func _on_login_btn_button_down():
	# Auth user
	
	# switch scenses with the scene manager
	get_tree().change_scene_to_file("res://Scenes/gameManager.tscn")
	
	pass # Replace with function body.


func _on_signup_btn_button_down():
	#switch to the scene manager
	get_tree().change_scene_to_file("res://Scenes/gameManager.tscn")
	pass # Replace with function body.
