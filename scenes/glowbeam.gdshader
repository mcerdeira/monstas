shader_type canvas_item;

uniform float speed = 2.5;
uniform float alpha_value = 0.15;

void fragment()
{
	float h = UV.x * 2.0 + TIME * speed;

	vec3 rainbow =
		0.5 +
		0.5 *
		cos(
			6.28318 *
			(
				h +
				vec3(0.0, 0.33, 0.66)
			)
		);

	float alpha = alpha_value;

	COLOR = vec4(rainbow, alpha);
}