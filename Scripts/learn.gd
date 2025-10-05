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
	update_info()

func update_info():
	learn_card.title.text = asteroids[current_index]["name"]
	var neo_reference_id = asteroids[current_index]["neo_reference_id"]
	var designation = asteroids[current_index]["designation"]
	var estimated_diameter = asteroids[current_index]["estimated_diameter"]
	var is_potentially_hazardous_asteroid = asteroids[current_index]["is_potentially_hazardous_asteroid"]
	learn_card.info.text = "neo_reference_id: "
	learn_card.info.text += neo_reference_id + "\n"
	learn_card.info.text += "designation: "
	learn_card.info.text += designation + "\n"
	#learn_card.info.text = "estimated_diameter: "
	#learn_card.info.text += estimated_diameter + "\n"
	learn_card.info.text += "is_potentially_hazardous_asteroid: "
	learn_card.info.text += str(is_potentially_hazardous_asteroid) + "\n"
	#["links", "id", "neo_reference_id", "name", "name_limited", "designation", "nasa_jpl_url", "absolute_magnitude_h", "estimated_diameter", "is_potentially_hazardous_asteroid", "close_approach_data", "orbital_data", "is_sentry_object"]


func _on_asteroids_button_down() -> void:
	print("hello")

func _on_mitigation_button_down() -> void:
	print("hello")


func _on_environmental_button_down() -> void:
	print("hello")


func _on_button_left_button_down() -> void:
	current_index = (current_index - 1 + asteroids.size()) % asteroids.size()
	update_info()

func _on_button_right_button_down() -> void:
	current_index = (current_index + 1) % asteroids.size()
	update_info()
