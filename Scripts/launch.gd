extends Node

@onready var next_button: Button = $NextButton
@onready var status_label: Label = $StatusLabel
@onready var asteroid_card: TextureRect = $AsteroidCard
@onready var hit_marker: Control = $HitMarker

@onready var http_request: HTTPRequest = $HTTPRequest

const HIT_MARKER = preload("res://Scenes/hit_marker.tscn")

var current_asteroid_index = 0

var current_card = 0

const _1 = preload("uid://cvpgqgx1r3n34")
const _2 = preload("uid://0k0qqn6x4l2u")
const _3 = preload("uid://d1kohb7frrb6i")
const _4 = preload("uid://def2spo520pc0")
const _5 = preload("uid://b7rybkt6fsbgt")

var asteroids = [_1, _2, _3, _4, _5]

func _ready():
	var pos = get_random_position()
	hit_marker.position = pos


var screen_width = 1920 / 0.9
var screen_height = (1080 - 300) / 0.9

func get_random_position() -> Vector2:
	var x = randi_range(0, screen_width - 1)
	var y = randi_range(0, screen_height - 1)
	return Vector2(x, y)


func _on_button_1_button_down() -> void:
	current_card = 1


func _on_button_2_button_down() -> void:
	current_card = 2


func _on_button_3_button_down() -> void:
	current_card = 3


func _on_activate_button_down() -> void:
	var status = true
	if status:
		status_label.show()
		status_label.text = "win"
		next_button.show()
	else:
		status_label.show()
		status_label.text = "lose"
		next_button.show()

func _on_next_button_button_down() -> void:
	current_asteroid_index = (current_asteroid_index + 1) % asteroids.size()
	asteroid_card.texture = asteroids[current_asteroid_index]
	status_label.hide()
	next_button.hide()
	
	var pos = get_random_position()
	hit_marker.position = pos
