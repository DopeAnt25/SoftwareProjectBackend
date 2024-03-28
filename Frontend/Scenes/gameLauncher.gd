extends Control

func _ready():
	get_user_data()

func _on_redox_game_section_pressed():
	## enter redox teams game file path
	pass


func _on_precipitation_game_section_pressed():
	## enter precipitation team game file path
	pass 


func _on_acid_and_base_game_section_pressed():
	## enter acidandbase team game file path
	get_tree().change_scene_to_file("res://acidbase/Scene_Handler.tscn")


func get_user_data():
	var auth = Firebase.Auth.auth 
	if auth.localid:
		var collection : FirestoreCollection = Firebase.Firestore.collection('users')
		var task : FirestoreTask = collection.get_doc(auth.localid)
		await task.task_finished
		var document = task.document
		$ProfileScreen/ColorRect2/NameLabel.text = "Username: " + document['doc_fields']['name']
		$ProfileScreen/ColorRect2/EmailLabel.text = "Email: " + document['doc_fields']['email']
		var isTeacher = document['doc_fields']['isTeacher']
		if isTeacher:
			$ProfileScreen/ColorRect2/DashboardLabel.text = "Dashboard Layout: Teacher"
		else:
			$ProfileScreen/ColorRect2/DashboardLabel.text = "Dashboard Layout: Student"


func _on_change_password_button_pressed():
	var email_input = $ProfileScreen/ColorRect2/EmailLabel.text
	var email = email_input.replace("Email: ", "").strip_edges()
	Firebase.Auth.send_password_reset_email(email)


func _on_change_email_button_pressed():
	var email_input = $ProfileScreen/ColorRect2/EmailLabel.text
	var email = email_input.replace("Email: ", "").strip_edges()
	print(email)
	Firebase.Auth.change_user_email(email)


func _on_logout_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/login.tscn")
	Firebase.Auth.logout()


func _on_profile_icon_pressed():
	$GameSelectScreen.visible = false
	$ProfileScreen.visible = true
