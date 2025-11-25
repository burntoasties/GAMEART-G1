extends VideoStreamPlayer

# 1. Export the path to your looping video
@export var loop_video_path: String = "res://videos/title_screen_loop.ogv"

# 2. Store the initial video stream to restore it later if needed
var original_stream: VideoStream

func _ready():
	# Store the original stream (your intro video)
	original_stream = stream
	
	# Ensure the stream is not set to loop by default
	loop = false
	
	# Connect the signal that tells us when the current video is done playing
	connect("finished", _on_video_finished)
	
	# Start the initial video
	play()
	print("Starting intro video...")

# This function is called automatically when the video stops playing (reaches its end)
func _on_video_finished():
	print("Intro video finished. Switching to loop segment.")
	
	# 1. Create a new video stream object for the loop segment
	var new_stream = VideoStreamTheora.new()
	
	# 2. Load the looping video file from the path
	new_stream.file = loop_video_path
	
	# 3. Assign the new stream to the VideoStreamPlayer
	stream = new_stream
	
	# 4. CRITICAL: Set the Godot loop property to true for the new stream
	loop = true
	
	# 5. Start the playback of the new stream
	play()
