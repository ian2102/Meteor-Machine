extends Node

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var learn_card: Control = $LearnCard

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

func _on_asteroids_button_down() -> void:
	print("hello")

func _on_mitigation_button_down() -> void:
	print("hello")


func _on_environmental_button_down() -> void:
	print("hello")


func _on_button_left_button_down() -> void:
	current_index = (current_index - 1 + asteroids.size()) % asteroids.size()
	learn_card.title.text = asteroids[current_index]["name"]
	learn_card.info.text = str(asteroids[current_index].keys())

func _on_button_right_button_down() -> void:
	current_index = (current_index + 1) % asteroids.size()
	learn_card.title.text = asteroids[current_index]["name"]
	learn_card.info.text = str(asteroids[current_index].keys())
