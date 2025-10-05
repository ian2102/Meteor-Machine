extends Node

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var learn_card: Control = $LearnCard

var asteroids = []
var current_index = 0
var selected_section = 0

var current_card_index = 0
var defense_cards = []

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
	var error = http_request.request("https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=mIYsnrgYn3Nh3zKR0V3IvSvQo4ghKAfpGDEEdBmE")
	if error != OK:
		print("An error occurred in the HTTP request.")
	
	defense_cards = get_colored_pngs("res://Assets/cards/defense/")

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	#print(json)
	# TODO error handing
	for object in json["near_earth_objects"]:
		#print(object["name"])
		asteroids.append(object)
	update_asteroid_info()

func update_asteroid_info():
	learn_card.texture_rect.texture = null
	learn_card.title.text = asteroids[current_index]["name"]
	var neo_reference_id = asteroids[current_index]["neo_reference_id"]
	var designation = asteroids[current_index]["designation"]
	var estimated_diameter_min = asteroids[current_index]["estimated_diameter"]["kilometers"]["estimated_diameter_min"]
	var estimated_diameter_max = asteroids[current_index]["estimated_diameter"]["kilometers"]["estimated_diameter_max"]
	var unit = "km"
	if estimated_diameter_max < 1:
		unit = "m"
		estimated_diameter_min = asteroids[current_index]["estimated_diameter"]["meters"]["estimated_diameter_min"]
		estimated_diameter_max = asteroids[current_index]["estimated_diameter"]["meters"]["estimated_diameter_max"]
	var is_potentially_hazardous_asteroid = asteroids[current_index]["is_potentially_hazardous_asteroid"]
	var sys_time = int(Time.get_unix_time_from_system())
	var pass_time
	var readable_time
	var dist_au
	var dist_lu
	var dist_km
	var vel_kms
	var vel_kmh
	for time in asteroids[current_index]["close_approach_data"]:
		pass_time = time["epoch_date_close_approach"]/1000
		if pass_time > sys_time:
			readable_time = time["close_approach_date"]
			dist_au = time["miss_distance"]["astronomical"]
			dist_lu = time["miss_distance"]["lunar"]
			dist_km = time["miss_distance"]["kilometers"]
			vel_kms = time["relative_velocity"]["kilometers_per_second"]
			vel_kmh = time["relative_velocity"]["kilometers_per_hour"]
			break
	learn_card.info.text = "Neo reference id: "
	learn_card.info.text += neo_reference_id + "\n"
	learn_card.info.text += "Designation: "
	learn_card.info.text += designation + "\n"
	learn_card.info.text += "Estimated_diameter: "
	learn_card.info.text += "%0.2f-%0.2f%s\n" % [estimated_diameter_min, estimated_diameter_max, unit]
	learn_card.info.text += "Potentially hazardous asteroid: "
	learn_card.info.text += str(is_potentially_hazardous_asteroid) + "\n"
	learn_card.info.text += "Next nearest pass: "
	learn_card.info.text += str(readable_time) + "\n"
	learn_card.info.text += "Distance in astromical units: "
	learn_card.info.text += str(dist_au) + "\n"
	learn_card.info.text += "Distance in lunar units: "
	learn_card.info.text += str(dist_lu) + "\n"
	learn_card.info.text += "Distance in kilometers: "
	learn_card.info.text += str(dist_km) + "\n"
	learn_card.info.text += "Relative velocity in kilometers per second: "
	learn_card.info.text += str(vel_kms) + "\n"
	learn_card.info.text += "Relative velocity in kilometers per hour: "
	learn_card.info.text += str(vel_kmh) + "\n"
	#["links", "id", "neo_reference_id", "name", "name_limited", "designation", "nasa_jpl_url", "absolute_magnitude_h", "estimated_diameter", "is_potentially_hazardous_asteroid", "close_approach_data", "orbital_data", "is_sentry_object"]

func update_environmental_info():
	learn_card.texture_rect.texture = null
	learn_card.title.text = "Environmental Impact"
	learn_card.info.text = "Asteroid impacts can trigger massive environmental disasters. A strike in the ocean may cause tsunamis that devastate coastlines, while land impacts can produce earthquakes and shockwaves. Dust and debris thrown into the atmosphere can block sunlight, disrupting climate and agriculture. Firestorms, acid rain, and long-term ecological collapse are also possible, depending on the asteroid’s size and speed."

func update_defense_cards_info():
	learn_card.title.text  = ""
	learn_card.info.text = ""
	learn_card.texture_rect.texture = defense_cards[current_card_index][0]

func _on_asteroids_button_down() -> void:
	selected_section = 0
	update_asteroid_info()

func _on_environmental_button_down() -> void:
	selected_section = 1
	update_environmental_info()

func _on_mitigation_button_down() -> void:
	selected_section = 2
	update_defense_cards_info()

func _on_button_left_button_down() -> void:
	match selected_section:
		0:
			current_index = (current_index - 1 + asteroids.size()) % asteroids.size()
			update_asteroid_info()
		1:
			pass
		2:
			current_card_index = (current_card_index - 1 + defense_cards.size()) % defense_cards.size()
			update_defense_cards_info()

func _on_button_right_button_down() -> void:
	match selected_section:
		0:
			current_index = (current_index + 1) % asteroids.size()
			update_asteroid_info()
		1:
			pass
		2:
			current_card_index = (current_card_index + 1) % defense_cards.size()
			update_defense_cards_info()


func _on_return_button_button_down() -> void:
	queue_free()
