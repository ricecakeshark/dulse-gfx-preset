#version 460
#extension GL_EXT_scalar_block_layout : enable

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 0, binding = 0) uniform sampler2D depth_texture;
layout(set = 0, binding = 1) uniform sampler2D albedo_texture;
layout(set = 0, binding = 2) uniform sampler2D normal_texture;
layout(set = 0, binding = 3) uniform sampler2D material_texture;
// Light
struct LightPoint
{
	vec4 pos;
	vec4 color;
	//float intensity;
};
layout(std430, set = 0, binding = 4) readonly buffer Light
{
	uint count;
	LightPoint[] list;
} light;
// write texture
layout(set = 1, binding = 0, rgba16f) uniform writeonly image2D color_texture;
//layout(set = 1, binding = 1, rgba32f) uniform writeonly image2D specular_texture;

// Scene
layout(std430, set = 2, binding = 0) uniform Scene
{
	vec4 light_ambient;
} scene;
// View
layout(std430, set = 2, binding = 1) uniform View
{
	layout(row_major) mat4 mat_view_proj;
	layout(row_major) mat4 mat_inv_view_proj;
	vec3 vec_pos;
} view;

vec3 reconstruct_world_pos(const in vec2 uv, const in float depth);
float calc_attenuation(const in float d);

void main()
{
	const ivec2 screen_pos = ivec2(gl_GlobalInvocationID.xy);
	const ivec2 image_size = imageSize(color_texture);
	if(screen_pos.x >= image_size.x || screen_pos.y >= image_size.y)
	{
		return;
	}
	const vec2 uv = vec2((vec2(screen_pos) + 0.5) / vec2(image_size));
	// prepare
	const vec4 albedo_color = texelFetch(albedo_texture, screen_pos, 0);
	const vec3 normal_world = normalize(texture(normal_texture, uv).rgb);
	const vec3 world_pos = reconstruct_world_pos(uv, texelFetch(depth_texture, screen_pos, 0).r);
	const vec3 vec_view = normalize(view.vec_pos - world_pos);
	const vec2 material_info = texelFetch(material_texture, screen_pos, 0).xy;
	const float specular_strength = material_info.x;
	const float shininess = material_info.y;

	// ambient light
	const vec3 ambient = scene.light_ambient.rgb * scene.light_ambient.a;

	//const vec3 diffuse = light.list[0].color.xyz * light.list[0].intensity * diff;
	vec3 diffuse = vec3(0.0, 0.0, 0.0);
	vec3 specular = vec3(0.0, 0.0, 0.0);
	for(uint count = 0; count < light.count; ++count)
	{
		// prepare per light
		const vec3 vec_light = light.list[count].pos.xyz - world_pos;
		const vec3 dir_light = normalize(vec_light);
		const float dist_light = length(vec_light);
		const float attenuation = calc_attenuation(dist_light);
		
		// diffuse light
		const float diff = max(dot(normal_world, dir_light), 0.0);
		diffuse += light.list[count].color.xyz * light.list[count].color.a
			 * diff * attenuation;

		if(diff > 0.0)
		{
			// specular light
			// 1. phong
			//const vec3 vec_reflect = reflect(-dir_light, normal_world);
			//const float spec = pow(max(dot(vec_view, vec_reflect), 0.0), shininess);
			// 2. blin-phong
			const vec3 harf_vec = normalize(dir_light + vec_view);
			const float spec = pow(clamp(dot(normal_world, harf_vec), 0.0, 1.0), shininess);
			// sum of specular
			specular += light.list[count].color.xyz
			* light.list[count].color.a * specular_strength * spec * attenuation;
		}
	}
	
	imageStore(color_texture, screen_pos, vec4((diffuse + ambient) * albedo_color.rgb + specular, albedo_color.a));
	//imageStore(color_texture, screen_pos, vec4(light.list[1].color.xyz, 1.0));
	return;
}

vec3 reconstruct_world_pos(const in vec2 uv, const in float depth)
{
	const vec4 clip_pos = vec4(
		uv.x * 2.0 - 1.0,
		uv.y * 2.0 - 1.0,
		depth,
		1.0
	);
	vec4 world_pos = clip_pos * view.mat_inv_view_proj;
	world_pos.xyz /= world_pos.w;
	return world_pos.xyz;
}

float calc_attenuation(const in float d)
{
	return 1.0 / (1.0 + 0.09 * d + 0.032 * pow(d, 2.0));
}