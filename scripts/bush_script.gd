extends Sprite2D

@export var TEXTURE_VAR: int = 2
@export var TEXTURE_WIDTH: int = 32

var wind_offset =  randf_range(1, 3)

func _get_wind_offset() -> int:
	return wind_offset

func variate_texture():
	var skips: int = randi() % TEXTURE_VAR
	region_rect.position.x += skips * TEXTURE_WIDTH

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	variate_texture()
	set_instance_shader_parameter("offset", wind_offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
