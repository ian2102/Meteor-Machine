extends Node

@onready var next_button: Button = $NextButton
@onready var status_label: Label = $StatusLabel
@onready var asteroid_card: TextureRect = $AsteroidCard
@onready var hit_marker: Control = $HitMarker

@onready var score_label: Label = $ScoreLabel

@onready var card_1: Button = $HBoxContainer/Card1
@onready var card_2: Button = $HBoxContainer/Card2
@onready var card_3: Button = $HBoxContainer/Card3

@onready var http_request: HTTPRequest = $HTTPRequest

const HIT_MARKER = preload("res://Scenes/hit_marker.tscn")

var current_asteroid_index = 0
var selected_card = 0
var next_card_index = 0

var cards_data = [null, null, null]

var asteroid_data = null

var asteroids = []
var cards = []

var score = 0

func get_colored_pngs(path: String) -> Array:
	var results: Array = []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".png"):
				# Full path to file
				var full_path = path.path_join(file_name)

				# Load texture
				var texture: Texture2D = load(full_path)

				# Extract color (string between "_" and ".png")
				# Example: "1_red.png" -> "red"
				var parts = file_name.split("_")
				if parts.size() > 1:
					var color_part = parts[1].replace(".png", "")
					results.append([texture, color_part])
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Could not open folder: " + path)
	return results

func set_hit_location():
	var pos = get_random_position()
	hit_marker.position = pos

func _ready():
	asteroids = get_colored_pngs("res://Assets/cards/asteroids/")
	cards = get_colored_pngs("res://Assets/cards/defense/")
	asteroids.shuffle()
	cards.shuffle()
	set_hit_location()
	card_1.icon = cards[0][0]
	cards_data[0] = cards[0]
	
	card_2.icon = cards[1][0]
	cards_data[1] = cards[1]
	
	card_3.icon = cards[2][0]
	cards_data[2] = cards[2]
	
	next_card_index = 3
	
	asteroid_card.texture = asteroids[0][0]
	asteroid_data = asteroids[0]

var screen_width = (1920 - 300) / 0.9
var screen_height = (1080 - 600) / 0.9

func get_random_position() -> Vector2:
	var x = randi_range(0, screen_width - 1)
	var y = randi_range(0, screen_height - 1)
	return Vector2(x, y)


func _on_button_1_button_down() -> void:
	selected_card = 0


func _on_button_2_button_down() -> void:
	selected_card = 1


func _on_button_3_button_down() -> void:
	selected_card = 2

func _on_activate_button_down() -> void:
	var status = (asteroid_data[1] == cards_data[selected_card][1])
	if status:
		status_label.show()
		status_label.text = "RESULT_SUCCESS: +1"
		score += 1
		next_button.show()
	else:
		status_label.show()
		status_label.text = "RESULT_FAILURE: -1"
		if score > 0:
			score -= 1
		next_button.show()
	
	score_label.text = "Score: " + str(score)
	
	next_card_index = (next_card_index + 1) % cards.size()
	
	match selected_card:
		0:
			card_1.icon = cards[next_card_index][0]
		1:
			card_2.icon = cards[next_card_index][0]
		2:
			card_3.icon = cards[next_card_index][0]
	
	cards_data[selected_card] = cards[next_card_index]

func _on_next_button_button_down() -> void:
	current_asteroid_index = (current_asteroid_index + 1) % asteroids.size()
	asteroid_card.texture = asteroids[current_asteroid_index][0]
	asteroid_data = asteroids[current_asteroid_index]

	status_label.hide()
	next_button.hide()
	
	set_hit_location()

func _on_return_button_button_down() -> void:
	queue_free()
