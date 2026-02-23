shader_type spatial;

uniform sampler2D displacement_map : hint_normal;
uniform float displacement_strength = 1.0;

void vertex() {
vec4 disp = texture(displacement_map, UV);
VERTEX += NORMAL * disp.r * displacement_strength;
}