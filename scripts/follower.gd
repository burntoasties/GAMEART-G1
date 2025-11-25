extends Node2D

var ACCELERATION : float
var FRICTION : float

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var mat := sprite.material

var tilt := 0.0
var tilt_strength := 0.5
var tilt_speed := 8.0

var _player_moving: bool = false
var _target_pos: Vector2
var _look_dir: Vector2
var _last_look_dir_y: float = 1

func _physics_process(delta: float) -> void:
	var old_pos: Vector2 = global_position
	var pos_lerp_weight: float = 1.0 - exp( -(ACCELERATION if _player_moving else FRICTION ) * delta)
	global_position = lerp(global_position, _target_pos, pos_lerp_weight)

func _play_animation(anim_name: String) -> void:
	if !anim:
		return
	
	if anim.has_animation(anim_name):
		anim.play(anim_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mat:
		var target_tilt := 0.0
		
		if _player_moving:
			target_tilt = _look_dir.x * tilt_strength
		
		tilt = lerp(tilt, target_tilt, delta * tilt_speed)
		
		mat.set("shader_parameter/look_dir", Vector2(tilt, 0.0))
	
	if _look_dir == Vector2.ZERO:
		return
	
	if abs(_look_dir.x) > abs(_look_dir.y):
		if _look_dir.x > 0:
			_play_animation("right")
		else:
			_play_animation("left")
	
	else:
		if _look_dir.y > 0:
			_play_animation("down")
		else:
			_play_animation("up")
