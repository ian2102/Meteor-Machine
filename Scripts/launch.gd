extends Node

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var learn_card: Control = $LearnCard
const HIT_MARKER = preload("res://Scenes/hit_marker.tscn")

var asteroids = []
var current_index = 0

func _ready():
	var error = http_request.request("https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=mIYsnrgYn3Nh3zKR0V3IvSvQo4ghKAfpGDEEdBmE")
	if error != OK:
		print("An error occurred in the HTTP request.")

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	#print(json)
	# TODO error handing
	for object in json["near_earth_objects"]:
		#print(object["name"])
		asteroids.append(object)
	
	learn_card.title.text = asteroids[current_index]["name"]
	learn_card.info.text = str(asteroids[current_index].keys())
	var pos = get_random_position()
	var hit_marker = HIT_MARKER.instantiate()
	hit_marker.position = pos
	add_child(hit_marker)
	

var screen_width = 1920
var screen_height = 1080

func get_random_position() -> Vector2:
	var x = randi_range(0, screen_width - 1)
	var y = randi_range(0, screen_height - 1)
	return Vector2(x, y)
