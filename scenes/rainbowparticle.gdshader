shader_type particles;

const vec3 COLORS[7] = vec3[](
    vec3(1.0, 0.0, 0.0),   // rojo
    vec3(1.0, 0.5, 0.0),   // naranja
    vec3(1.0, 1.0, 0.0),   // amarillo
    vec3(0.0, 1.0, 0.0),   // verde
    vec3(0.0, 1.0, 1.0),   // cyan
    vec3(0.0, 0.3, 1.0),   // azul
    vec3(0.6, 0.0, 1.0)    // violeta
);

void process() {

    // convertir seed a float (CLAVE)
    float seed = float(RANDOM_SEED);

    // pseudo-random estable por partícula
    float r = fract(sin(seed) * 43758.5453);

    int idx = int(r * 7.0);
    idx = clamp(idx, 0, 6);

    COLOR.rgb = COLORS[idx];
    COLOR.a = 1.0;
}