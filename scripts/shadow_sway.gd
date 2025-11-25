extends "res://scripts/random_sway.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var wind_offset = wind_offset
	set_instance_shader_parameter("offset", wind_offset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
