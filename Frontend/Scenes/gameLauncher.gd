extends Control

func _ready():
	get_user_setting_data()
	get_user_score_data()

func _on_redox_game_section_pressed():
	## enter redox teams game file path
	pass


func _on_precipitation_game_section_pressed():
	## enter precipitation team game file path
	pass 


func _on_acid_and_base_game_section_pressed():
	## enter acidandbase team game file path
	pass


func get_user_setting_data():
	var auth = Firebase.Auth.auth 
	if auth.localid:
		var collection : FirestoreCollection = Firebase.Firestore.collection('users')
		var task : FirestoreTask = collection.get_doc(auth.localid)
		await task.task_finished
		var document = task.document.doc_fields
		$ProfileScreen/ColorRect2/NameLabel.text = "Username: " + document['name']
		$ProfileScreen/ColorRect2/EmailLabel.text = "Email: " + document['email']
		var isStudent = document['isStudent']
		if isStudent:
			$ProfileScreen/ColorRect2/DashboardLabel.text = "Dashboard Layout: Student"
		else:
			$ProfileScreen/ColorRect2/DashboardLabel.text = "Dashboard Layout: Teacher"


func get_user_score_data():
	var auth = Firebase.Auth.auth
	var collection : FirestoreCollection = Firebase.Firestore.collection('users')
	var task : FirestoreTask = collection.get_doc(auth.localid)
	await task.task_finished
	var document = task.document.doc_fields
	
	# Student Screen
	### Add code for progress bars
	$ScoreScreen/ScoreScreen/Label.text = "Scores for: " + document['name']
	
	
	$ScoreScreen/ScoreScreen/RedoxScore.value = (float(document['scores']['redox']['r_progress']) / 3) * 100
	$ScoreScreen/ScoreScreen/PQScore.value = (float(document['scores']['pq']['pq_progress']) / 3) * 100
	$ScoreScreen/ScoreScreen/AcidandBaseScore.value = (float(document['scores']['acidsbases']['ab_progress']) / 27) * 100

	# Teacher Screen
	### Add code for drop down menus for only teachers, we could also do an export to cvs button for each class


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


func _on_texture_button_pressed():
	$GameSelectScreen.visible = false
	$ScoreScreen.visible = true
