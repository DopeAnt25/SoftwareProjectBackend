extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	
	$ColorRect.visible = false
	$ColorRect2.visible = true
	pass # Replace with function body.


func on_login_succeeded(auth):
	get_tree().change_scene_to_file("res://Scenes/gameManager.tscn")


func on_login_failed(error_code, message):
	pass


func on_signup_succeeded(auth):
	var username = $ColorRect/Username.text
	var email = $ColorRect/Email.text
	var name = $ColorRect/name.text
	var isTeacher = $ColorRect/StudentTeacherCheck.button_pressed

	if auth.localid:
		var collection : FirestoreCollection = Firebase.Firestore.collection("users")
		var task : FirestoreTask = collection.add(auth.localid, {
			"username": username,
			"email": email,
			"name": name,
			"isTeacher": isTeacher
		})
		
		await task.task_finished
		
		get_tree().change_scene_to_file("res://Scenes/gameManager.tscn")



func on_signup_failed(error_code, message):
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
	var email = $ColorRect2/Email.text
	var password = $ColorRect2/Password.text
	Firebase.Auth.login_with_email_and_password(email, password)


func _on_signup_btn_button_down():
	#switch to the scene manager
	var email = $ColorRect/Email.text
	var password = $ColorRect/password2.text
	Firebase.Auth.signup_with_email_and_password(email, password)
