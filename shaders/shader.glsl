#version 460 core
precision mediump float;
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D uTexture;
uniform sampler2D dissolve_texture ;
uniform float dissolve_value;
uniform float burn_size;
out vec4 fragColor;

void main() {
    vec2 coo = FlutterFragCoord().xy/uSize;
    vec4 main_texture = texture(uTexture, coo);
     vec4 color = texture(uTexture, coo);
    vec4 noise_texture = texture(dissolve_texture, coo);
    float burn_size_step = burn_size * step(0.001, dissolve_value) * step(dissolve_value, 0.999);
	float threshold = smoothstep(noise_texture.x-burn_size_step, noise_texture.x, dissolve_value);
	float border = smoothstep(noise_texture.x, noise_texture.x + burn_size_step, dissolve_value);
	vec4 burn_color=vec4(1.0,0,0.0,0.1);
    burn_color.a=0.5;
	color.a *= threshold;
	color.rgb = mix(burn_color.rgb, main_texture.rgb, border);
    fragColor = color;
}