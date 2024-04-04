extends PathFollow2D

signal base_damage(damage)
signal add_money(amount)

var SPEED = 50
var health = 20
var enemy_damage = 2
var base_health = 100
var cash = 1

@onready var health_bar = get_node("HealthBar")



func _ready():
	$CharacterBody2D/AnimatedSprite2D.play("walk")
	health_bar.max_value = health
	health_bar.value = health
	health_bar.set_as_top_level(true)
	


func _physics_process(delta):
	if get_progress() >= 3470.0:
		emit_signal("base_damage", enemy_damage)
		queue_free()
	move(delta)


func move(delta):
	set_progress(get_progress() + SPEED * delta)
	health_bar.position = position - Vector2(30,45)


func on_hit(damage):
	health -= damage
	health_bar.value = health
	if health <= 0:
		$CharacterBody2D/AnimatedSprite2D.play("dead")
		emit_signal("add_money", cash)
		await (get_tree().create_timer(0.18)).timeout
		on_destroy()

func on_destroy():
	self.queue_free()


