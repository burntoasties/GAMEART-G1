extends Sprite2D

var wind_offset =  randf_range(1, 3)

func _get_wind_offset() -> int:
	return wind_offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_instance_shader_parameter("offset", wind_offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
