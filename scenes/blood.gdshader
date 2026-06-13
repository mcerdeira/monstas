shader_type canvas_item;

uniform float reveal : hint_range(0.0, 1.0) = 0.0;
uniform vec2 origin = vec2(1.0, 1.0);

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    float dist = distance(UV, origin);

    if (dist > reveal) {
        discard;
    }

    COLOR = color;
}