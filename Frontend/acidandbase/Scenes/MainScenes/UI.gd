extends CanvasLayer

signal correct_answer
signal incorrect_answer

@onready var health_bar = get_node("HUD/Life/Label2")
@onready var money_count = get_node("HUD/Coins/Label")

var question_number = null
var question_active = false


##
## Main Screen Functions
##
func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://acidandbase/Scenes/Turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff")
	
	var range_texture = Sprite2D.new()
	range_texture.position = Vector2(32,32)
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://acidandbase/Assets/UI/tower range/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.set_position(mouse_position)
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)

func update_tower_preview(new_position, color):
	get_node("TowerPreview").set_position(new_position)
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite2D").modulate = Color(color)


func _on_pause_play_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
	elif get_parent().current_wave == 0:
		get_parent().current_wave += 1
		get_parent().start_next_wave()
	else:
		get_tree().paused = true


func _on_speed_up_pressed():
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)


func update_health(base_health):
	health_bar.text = str(base_health) 


func change_cash_amount(amount):
	money_count.text = "$" + str(amount)
	

##
## QUESTION BOX FUNCTIONS
##
func create_question():
	if get_node("HUD/QuestionBox").visible or question_active:
		get_node("HUD/QuestionBox").visible = true
		return

	if question_number == null:
		question_number = randi_range(1,20)
	update_question_ui(question_number)
	get_node("HUD/QuestionBox").visible = true
	question_active = true

func update_question_ui(question_index):
	#question_number = randi_range(1,27)
	print(question_index)
	$HUD/QuestionBox/VBoxContainer/QuestionLabel.text = GameData.questions[str(question_index)]["Question"]
	$HUD/QuestionBox/VBoxContainer/TextureButton/Label.text = GameData.questions[str(question_index)]["Options"]["1"]
	$HUD/QuestionBox/VBoxContainer/TextureButton2/Label.text = GameData.questions[str(question_index)]["Options"]["2"]
	$HUD/QuestionBox/VBoxContainer/TextureButton3/Label.text = GameData.questions[str(question_index)]["Options"]["3"]
	$HUD/QuestionBox/VBoxContainer/TextureButton4/Label.text = GameData.questions[str(question_index)]["Options"]["4"]

##
## Checks to make sure answer is correct
##
func check_answer(users_answer):
	if users_answer == GameData.questions[str(question_number)]["Answer"]:
		$"..".update_money(10)
		$"..".flask_answered()
		question_active = false
		question_number = null
		emit_signal("correct_answer")
		get_node("HUD/QuestionBox").visible = false
		$"../audio".stream = load("res://acidandbase/Assets/Audio/correct_answer.wav")
		$"../audio".play()
		
	else:
		$"../audio".stream = load("res://acidandbase/Assets/Audio/wrong_answer.mp3")
		$"../audio".play()
		$"..".on_base_damage(1)
		$"..".flask_answered()
		question_active = false
		question_number = null
		emit_signal("incorrect_answer")
		get_node("HUD/QuestionBox").visible = false


func _on_texture_button_pressed():
	check_answer($HUD/QuestionBox/VBoxContainer/TextureButton/Label.text)


func _on_texture_button_2_pressed():
	check_answer($HUD/QuestionBox/VBoxContainer/TextureButton2/Label.text)


func _on_texture_button_3_pressed():
	check_answer($HUD/QuestionBox/VBoxContainer/TextureButton3/Label.text)


func _on_texture_button_4_pressed():
	check_answer($HUD/QuestionBox/VBoxContainer/TextureButton4/Label.text)


func _on_exit_question_button_pressed():
	$HUD/QuestionBox.visible = false


##
## MENU FUNCTIONS
##
func _on_resume_button_pressed():
	$HUD/PauseMenu.visible = false


func _on_gun_mouse_entered():
	print("ENTER")
	$HUD/infobox4.visible = true


func _on_gun_mouse_exited():
	$HUD/infobox4.visible = false


func _on_missile_mouse_entered():
	$HUD/infobox3.visible = true


func _on_missile_mouse_exited():
	$HUD/infobox3.visible = false


func _on_doubleshooter_mouse_entered():
	$HUD/infobox2.visible = true


func _on_doubleshooter_mouse_exited():
	$HUD/infobox2.visible = false


func _on_tripleshooter_mouse_entered():
	$HUD/infobox.visible = true


func _on_tripleshooter_mouse_exited():
	$HUD/infobox.visible = false
