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
			"classroom": null,
			"scores": {
				"acidsbases": {
					"ab_progress" : 0
				},
				"pq": {
					"pq_progress" : 0
				},
				"redox": {
					"r_progress" : 0
				}
			}})
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
	
	if auth.localid and await classroom_exists(class_code, auth.localid):
		# adding classroom to student account
		var collection : FirestoreCollection = Firebase.Firestore.collection('users')
		var task : FirestoreTask = collection.update(auth.localid, {"classroom" : class_code})
		await task.task_finished
		print("ADDED CLASS TO STUDENTS ACCOUNT")
		
		# adding student to classroom
		collection = Firebase.Firestore.collection('classrooms')
		task = collection.get_doc(class_code)
		await task.task_finished
		
		var student_array = task.document.doc_fields.students
		student_array.append(auth.localid)
		task = collection.update(class_code, {"students" : student_array})
		await task.task_finished
		
		get_tree().change_scene_to_file("res://Scenes/gameLauncher.tscn")
		
	else:
		$ColorRect/ClassCodeScreen/ErrorText.text = "ERROR: Classroom does not exists"


func classroom_exists(classroom_code : String, user_id : String) -> bool:
	var collection = Firebase.Firestore.collection('classrooms')
	var task = collection.get_doc(classroom_code)
	await task.task_finished
	
	if not task.error:
		return true
	else:
		return false
