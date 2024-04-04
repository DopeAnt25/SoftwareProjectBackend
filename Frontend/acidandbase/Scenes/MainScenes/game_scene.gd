extends Node2D

signal game_finished(result)

var map_node

var current_wave = 0
var enemies_in_wave = 0

var base_health = 100
var money = 50

var build_mode = false
var build_valid = false
var build_tile 
var build_location
var build_type
var category

var number_of_flask = 0
var spawn_flask = true

var is_pause_menu_visible = false


func _ready():
	map_node = get_node("Map1")
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(initiate_build_mode.bind(i.name))


func _process(_delta):
	check_money_and_price()
	check_and_spawn_flask()
	if build_mode:
		update_tower_preview()


func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()
	if event.is_action_pressed("pause"):
		if is_pause_menu_visible:
			get_node("UI/HUD/PauseMenu").visible = false
			is_pause_menu_visible = false
		else:
			get_node("UI/HUD/PauseMenu").visible = true
			is_pause_menu_visible = true


##
## Wave Functions
##
func start_next_wave():
	var wave_data = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)


func retrieve_wave_data():
	var wave_data = create_enemy_wave(current_wave)

	current_wave += 1
	return wave_data


func create_enemy_wave(wave_number : int):
	var wave_data = []
	var enemy_availability = {
		"greenacid": 1,
		"blueacid": 3,
		"orangeacid": 5,
		"purpleacid": 7,
	}

	var base_enemy_count = 5
	var difficulty_scale = wave_number * 0.5 

	for enemy_type in enemy_availability.keys():
		if wave_number >= enemy_availability[enemy_type]:
			var enemy_count = int(base_enemy_count + difficulty_scale * (randi() % 2 + 1))
			difficulty_scale += 0.1

			for i in range(enemy_count):
				var spawn_delay = randf_range(0.5, 2.0)
				wave_data.append([enemy_type, spawn_delay])
	return wave_data


func spawn_enemies(wave_data : Array):
	for i in wave_data:
		var new_enemy = load("res://acidandbase/Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		new_enemy.connect("base_damage", Callable(self, "on_base_damage"))
		new_enemy.connect("add_money", Callable(self, "update_money"))
		map_node.get_node("Path2D").add_child(new_enemy, true)
		if i[1] > 0:
			await (get_tree().create_timer(i[1])).timeout
		else:
			await (get_tree().create_timer(randf_range(0.5, 3))).timeout
			
	await get_tree().create_timer(10.0).timeout
	start_next_wave()


##
## BUILDING FUNCTIONS
##
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	print(tower_type)
	build_type = tower_type + "t1"
	build_mode = true 
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())


func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
	var title_position = map_node.get_node("TowerExclusion").map_to_local(current_tile)
	
	if map_node.get_node("TowerExclusion").get_cell_source_id(0, current_tile) == -1:
		get_node("UI").update_tower_preview(title_position, "fff")
		build_valid = true 
		build_location = title_position
		build_tile = current_tile
	
	else:
		get_node("UI").update_tower_preview(title_position, "FF0000")
		build_valid = false


func cancel_build_mode():
	build_mode = false 
	build_valid = false 
	get_node("UI/TowerPreview").free()


func verify_and_build():
	if build_valid and money >= GameData.tower_data[build_type]['cost']:
		update_money(-GameData.tower_data[build_type]['cost'])
		var new_tower = load("res://acidandbase/Scenes/Turrets/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type
		new_tower.category = GameData.tower_data[build_type]["category"]
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(0, build_tile, 6, Vector2(1, 0))
		$audio.stream = load("res://acidandbase/Assets/Audio/build_turret.ogg")
		$audio.play()


##
## Flask / QUESTION BOXES
##
func check_and_spawn_flask():
	if spawn_flask:
		create_flask()
		spawn_flask = false


func create_flask():
	var flask = load("res://acidandbase/Scenes/MoneyFlask/MoneyFlask.tscn").instantiate()
	flask.position = Vector2((randf_range(0,1000)), (randf_range(6,525)))
	#$UI.connect("correct_answer", Callable(self, "_on_correct_answer"))
	#$UI.connect("incorrect_answer", Callable(self, "_on_incorrect_answer"))
	map_node.add_child(flask, true)
	number_of_flask += 1


func flask_answered():
	await get_tree().create_timer(10).timeout
	spawn_flask = true


##
## MIS FUNCTIONS
##
func on_base_damage(damage : int):
	base_health -= damage
	if base_health <= 0:
		emit_signal("game_finished", false)
	else:
		get_node("UI").update_health(base_health)


func update_money(amount : int):
	money += amount
	get_node("UI").change_cash_amount(money)

func check_money_and_price():
	var turret_cost = {
		"gun": 20,
		"missile": 45,
		"doubleshooter": 60,
		"tripleshooter": 150,
	}
	
	for turret in turret_cost.keys():
		var cost = turret_cost[turret]
		var label_path = "UI/HUD/InfoBar/BuildBar/" + turret + "/Label"
		var label_node = get_node_or_null(label_path)  # Using get_node_or_null to avoid errors if the path doesn't exist
		if label_node:
			if money < cost:
				label_node.modulate = Color(1, 0, 0)  # Red color for not affordable
			else:
				label_node.modulate = Color(1, 1, 1)  # White color for affordable
