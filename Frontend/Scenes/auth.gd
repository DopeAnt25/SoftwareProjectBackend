extends Control



func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)

##
## Firebase/Firestore connections
##
func on_login_succeeded(_auth):
	$ColorRect/LoginScreen/ErrorText.text = "Login Success!"
	get_tree().change_scene_to_file("res://Scenes/gameLauncher.tscn")


func on_login_failed(_error_code, message):
	$ColorRect/LoginScreen/ErrorText.text = "Error: " + message


func on_signup_succeeded(auth):
	var name = $ColorRect/SignUpScreen2/NameLine.text
	var email = $ColorRect/SignUpScreen2/EmailLine.text
	var isStudent = $ColorRect/SignUpScreen2/isStudent.button_pressed
	if auth.localid:
		var collection : FirestoreCollection = Firebase.Firestore.collection("users")
		if isStudent:
			var task : FirestoreTask = collection.add(auth.localid, {
			"email": email,
			"name": name,
			"isStudent": isStudent,
			"classroom": null
			})
			await task.task_finished
			$ColorRect/SignUpScreen2.visible = false
			$ColorRect/ClassCodeScreen.visible = true
		else:
			var task : FirestoreTask = collection.add(auth.localid, {
				"email": email,
				"name": name,
				"isStudent": isStudent,
				"classrooms": {}
			})
			await task.task_finished
			$ColorRect/SignUpScreen2.visible = false
			$ColorRect/LoginScreen.visible = true


func on_signup_failed(_error_code, message):
	$ColorRect/SignUpScreen2/ErrorText.text = "Error: " + message



##
## Button Functions
##

# login screen buttons
func _on_sign_up_button_pressed():
	print("button pressed")
	$ColorRect/LoginScreen.visible = false
	$ColorRect/SignUpScreen2.visible = true


func _on_login_button_pressed():
	var email = $ColorRect/LoginScreen/EmailLine.text 
	var password = $ColorRect/LoginScreen/PasswordLine.text 
	Firebase.Auth.login_with_email_and_password(email, password)


# signup screen buttons
func _on_sign_up_page_sign_up_button_pressed():
	var email = $ColorRect/SignUpScreen2/EmailLine.text
	var password = $ColorRect/SignUpScreen2/PasswordLine.text
	Firebase.Auth.signup_with_email_and_password(email, password)


func _on_back_button_pressed():
	$ColorRect/SignUpScreen2.visible = false
	$ColorRect/LoginScreen.visible = true


func _on_submit_class_code_button_pressed():
	var class_code = $ColorRect/ClassCodeScreen/ClassCode.text
	var auth = Firebase.Auth.auth 
	var doc_ref = Firebase.FirestoreTask.collection('users').document(auth.localid)
	var update_data = {"classroom": class_code}
	doc_ref.update(update_data)
	
	
	
	
	
