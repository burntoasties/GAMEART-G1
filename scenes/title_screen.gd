extends Control

@onready var start_button = $StartButton
@onready var quit_button = $QuitButton
@onready var button_timer = $ButtonTimer

func _ready():
	start_button.visible = false
	quit_button.visible = false
	button_timer.start(14.0)


func _on_timer_timeout() -> void:
	start_button.visible = true
	quit_button.visible = true


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
