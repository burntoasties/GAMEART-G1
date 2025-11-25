shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 50.0) = 10.0;  // The height of the bobbing
uniform float speed : hint_range(0.0, 10.0) = 1.0;       // The speed of the bobbing
uniform vec2 look_dir = vec2(0.0, 1.0);
uniform float tilt_strength : hint_range(0.0, 0.5) = 0.15;

uniform float tilt_angle : hint_range(-0.5, 0.5) = 0.0;

void fragment() {
    float offsetY = amplitude * sin(TIME * speed);
    COLOR = texture(TEXTURE, UV + vec2(0.0, offsetY) / 500.0);
}

void vertex() {
	float tilt = look_dir.x * tilt_strength;

	float s = sin(tilt);
	float c = cos(tilt);
	vec2 p = VERTEX;

	VERTEX = vec2(
    p.x * c - p.y * s,
    p.x * s + p.y * c
);
}