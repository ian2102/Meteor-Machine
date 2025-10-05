extends Node

@onready var next_button: Button = $NextButton
@onready var status_label: Label = $StatusLabel
@onready var asteroid_card: TextureRect = $AsteroidCard
@onready var hit_marker: Control = $HitMarker

@onready var http_request: HTTPRequest = $HTTPRequest

const HIT_MARKER = preload("res://Scenes/hit_marker.tscn")

var current_asteroid_index = 0
var selected_card = 0
var selected_card_index = 0

var asteroids = []
var cards = []

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


func _ready():
	asteroids = get_colored_pngs("res://Assets/cards/asteroids/")
	cards = get_colored_pngs("res://Assets/cards/defense/")
	var pos = get_random_position()
	hit_marker.position = pos

var screen_width = (1920 - 300) / 0.9
var screen_height = (1080 - 600) / 0.9

func get_random_position() -> Vector2:
	var x = randi_range(0, screen_width - 1)
	var y = randi_range(0, screen_height - 1)
	return Vector2(x, y)


func _on_button_1_button_down() -> void:
	selected_card = 1


func _on_button_2_button_down() -> void:
	selected_card = 2


func _on_button_3_button_down() -> void:
	selected_card = 3


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
	asteroid_card.texture = asteroids[current_asteroid_index][0]
	status_label.hide()
	next_button.hide()
	
	var pos = get_random_position()
	hit_marker.position = pos
