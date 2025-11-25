extends CharacterBody2D

const FOLLOWER_SCENE_PRELOAD = preload("res://scenes/follower.tscn")

@export var speed:float = 50.0
@export var accel: float = 25.0
@export var friction: float = 25.0

@onready var anim_tree:AnimationTree = get_node("AnimationTree")
@onready var player: AudioStreamPlayer2D = $SFX

var atkState = false
var sprinting = false
var footstep_timer = 0.0
var footstep_interval: float

var followers: Array[Node2D] = []
var distance_spacing: float = 20.0
var _trail_points: Array[Vector2] = []

func _ready() -> void:
	_spawn_follower()

func _physics_process(delta):
	footstep_timer -= delta
	
	if Input.is_action_just_pressed("attack"):
		anim_tree.get("parameters/playback").travel("Attack")
		atkState = true
		
		player.stream = preload("res://sound/SwordSwoosh.mp3")
		player.pitch_scale = randf_range(0.9, 1.1)
		
		player.play()
	
	var input_vec = Input.get_vector("left", "right", "up", "down") # Defined in engine settings
	
	if Input.is_action_pressed("sprint"):
		velocity = input_vec * speed * 1.75
		sprinting = true
	else:
		velocity = input_vec * speed
		sprinting = false
	
	if atkState == false:
		if input_vec == Vector2.ZERO:
			anim_tree.get("parameters/playback").travel("Idle")
		else:
			if sprinting:
				anim_tree.get("parameters/playback").travel("Run")
			else:
				anim_tree.get("parameters/playback").travel("Walk")
			
			anim_tree.set("parameters/Idle/BlendSpace2D/blend_position", input_vec)
			anim_tree.set("parameters/Run/BlendSpace2D/blend_position", input_vec)
			anim_tree.set("parameters/Walk/BlendSpace2D/blend_position", input_vec)
			anim_tree.set("parameters/Attack/BlendSpace2D/blend_position", input_vec)
			
			if footstep_timer <= 0.0:
				if Input.is_action_pressed("sprint"):
					footstep_interval = 0.3
				else:
					footstep_interval = 0.4
				
				footstep_timer = footstep_interval
				player.stream = preload("res://sound/GrassStep.wav")
				player.pitch_scale = randf_range(0.9, 1.1)
				player.play()
		
		move_and_slide()
		
		_follower_logic()

func _follower_logic() -> void:
	if _trail_points.is_empty() or _trail_points[0].distance_to(global_position) >= 1.0:
		_trail_points.push_front(global_position)
	
	var max_trail_length: float = followers.size() * distance_spacing
	while _trail_points.size() > max_trail_length:
		_trail_points.pop_back()
	
	for i in followers.size():
		var path_pos: Vector2 = get_point_along_trail(distance_spacing * (i + 1))
		followers[i]._player_moving = true if round(velocity) else false
		followers[i]._target_pos = path_pos
		followers[i]._look_dir = round((followers[i].global_position - path_pos).normalized()) * -1

func get_point_along_trail(distance: float) -> Vector2:
	var total: float = 0.0
	
	for i in range(_trail_points.size() - 1):
		var point_a: Vector2 = _trail_points[i]
		var point_b: Vector2 = _trail_points[i + 1]
		var segment_length: float = point_a.distance_to(point_b)
		if total + segment_length >= distance:
			var t: float = (distance - total) / segment_length
			return point_a.lerp(point_b, t)
		total += segment_length
	
	return _trail_points.back()

func _spawn_follower() -> void:
	var new_follower_scene: Node2D = FOLLOWER_SCENE_PRELOAD.instantiate()
	
	new_follower_scene.ACCELERATION = accel
	new_follower_scene.FRICTION = friction
	
	if _trail_points.is_empty():
		_trail_points.append(global_position)
	new_follower_scene.global_position = get_point_along_trail(distance_spacing * (followers.size() + 1))
	
	get_parent().add_child.call_deferred(new_follower_scene)
	
	followers.append(new_follower_scene)

# I'm trying to make the blink idle ansimation work, saving this for now
func _on_timer_timeout() -> void:
	pass

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	atkState = false
