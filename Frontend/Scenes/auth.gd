extends Control

func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)

##
## Firestore connections
##
func on_login_succeeded(auth):
	$ColorRect/LoginScreen/LoginScreen/ErrorText.text = "Login Success!"
	await get_tree().create_timer(3.0)


func on_login_failed(_error_code, message):
	$ColorRect/LoginScreen/LoginScreen/ErrorText.text = "Error: " + message


func on_signup_succeeded(auth):
	var name = $ColorRect/SignUpScreen2/SignUpScreen/MarginContainer/NameLine.text
	var email = $ColorRect/SignUpScreen2/SignUpScreen/MarginContainer2/EmailLine.text
	var isTeacher = $ColorRect/SignUpScreen2/SignUpScreen/isTeacher.button_pressed

	if auth.localid:
		var collection : FirestoreCollection = Firebase.Firestore.collection("users")
		var task : FirestoreTask = collection.add(auth.localid, {
			"email": email,
			"name": name,
			"isTeacher": isTeacher,
			"classrooms": {}
		})
		
		await task.task_finished
		
		get_tree().change_scene_to_file("res://Scenes/gameManager.tscn")


func on_signup_failed(_error_code, message):
	$ColorRect/SignUpScreen2/SignUpScreen/ErrorText.text = "Error: " + message


##
## Button Functions
##

# login screen buttons
func _on_sign_up_button_pressed():
	$ColorRect/LoginScreen.visible = false
	$ColorRect/SignUpScreen2.visible = true


func _on_login_button_pressed():
	var email = $ColorRect/LoginScreen/LoginScreen/MarginContainer/EmailLine.text 
	var password = $ColorRect/LoginScreen/LoginScreen/MarginContainer2/PasswordLine.text 
	Firebase.Auth.login_with_email_and_password(email, password)


# signup screen buttons
func _on_sign_up_page_sign_up_button_pressed():
	var email = $ColorRect/SignUpScreen2/SignUpScreen/MarginContainer2/EmailLine.text
	var password = $ColorRect/SignUpScreen2/SignUpScreen/MarginContainer3/PasswordLine.text
	Firebase.Auth.signup_with_email_and_password(email, password)


func _on_back_button_pressed():
	$ColorRect/SignUpScreen2.visible = false
	$ColorRect/LoginScreen.visible = true
	
