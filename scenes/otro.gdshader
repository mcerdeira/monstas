shader_type canvas_item;

uniform float speed = 2.0;

void fragment()
{
	float hue = UV.x + TIME * speed;

	vec3 col =
		0.5 + 0.5 *
		cos(
			6.28318 *
			(hue + vec3(0.0, 0.33, 0.66))
		);

	COLOR = vec4(col, 1.0);
}