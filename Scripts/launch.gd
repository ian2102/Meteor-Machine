extends Node

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var learn_card: Control = $LearnCard
const HIT_MARKER = preload("res://Scenes/hit_marker.tscn")

var current_index = 0

var current_card = 0

const _1 = preload("uid://cvpgqgx1r3n34")
const _2 = preload("uid://0k0qqn6x4l2u")
const _3 = preload("uid://d1kohb7frrb6i")
const _4 = preload("uid://def2spo520pc0")
const _5 = preload("uid://b7rybkt6fsbgt")

var asteroids = [_1, _2, _3, _4, _5]

func _ready():
	
	var pos = get_random_position()
	var hit_marker = HIT_MARKER.instantiate()
	hit_marker.position = pos
	add_child(hit_marker)


var screen_width = 1920 / 0.9
var screen_height = (1080 - 300) / 0.9

func get_random_position() -> Vector2:
	var x = randi_range(0, screen_width - 1)
	var y = randi_range(0, screen_height - 1)
	return Vector2(x, y)


func _on_button_1_button_down() -> void:
	if learn_card.visible == true:
		if current_card == 1:
			learn_card.hide()
		else:
			current_card = 1
	else:
		learn_card.show()
		current_card = 1


func _on_button_2_button_down() -> void:
	if learn_card.visible == true:
		if current_card == 2:
			learn_card.hide()
		else:
			current_card = 2
	else:
		learn_card.show()
		current_card = 2


func _on_button_3_button_down() -> void:
	if learn_card.visible == true:
		if current_card == 3:
			learn_card.hide()
		else:
			current_card = 3
	else:
		learn_card.show()
		current_card = 3
