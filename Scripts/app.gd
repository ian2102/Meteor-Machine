extends Node

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var label: Label = $CanvasLayer/Control/Label

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("quit"):
		get_tree().quit()

func _ready():
	var error = http_request.request("https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=DEMO_KEY")
	if error != OK:
		label.text = "An error occurred in the HTTP request."

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	label.text = ""
	for object in json["near_earth_objects"]:
		print(object["name"])
		label.text += object["name"] + "\n"
