extends Control
@onready var music_player = get_tree().root.get_node("Game/BGM")
func _ready():
	visible = false

func resume():
	visible = false
	get_tree().paused = false

func pause():
	visible = true
	get_tree().paused = true


func enablePause():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()

func _on_resume_button_pressed() -> void:
	resume()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _process(delta):
	enablePause()

func _on_toggle_music_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_player.playing = true
	else:
		music_player.playing = false
