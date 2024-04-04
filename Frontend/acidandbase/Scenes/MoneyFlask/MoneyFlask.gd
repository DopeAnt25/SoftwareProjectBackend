extends Node2D


func _ready():
	get_node("../../UI").connect("correct_answer", Callable(self, 'destroy_flask'))
	get_node("../../UI").connect("incorrect_answer", Callable(self, 'destroy_flask'))

func _on_clickable_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_node("../../UI").create_question()


func destroy_flask():
	print("DESTORYING FLASK")
	queue_free()
