extends Node2D

var enemy_array = []
var built = false
var enemy
var type
var category
var ready_to_fire = true


func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]['range']


func _physics_process(_delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
		if ready_to_fire:
			fire()
	else:
		enemy = null


func turn():
	if enemy:
		var direction_to_enemy = enemy.global_position - get_node("Turret").global_position
		var angle_to_enemy = atan2(direction_to_enemy.y, direction_to_enemy.x) + PI / 2
		get_node("Turret").rotation = angle_to_enemy


func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]


func fire():
	if(enemy.health <= 0):
		enemy_array.erase(enemy)
	ready_to_fire = false
	if category == "projectile":
		fire_gun()
	elif category == "missile":
		fire_missile()
		
	enemy.on_hit(GameData.tower_data[type]["damage"])
	await get_tree().create_timer(GameData.tower_data[type]['fire_rate']).timeout
	ready_to_fire = true

func fire_gun():
	get_node("AnimationPlayer").play("Fire")
	$audio.play()
	
func fire_missile():
	pass

func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)


func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
