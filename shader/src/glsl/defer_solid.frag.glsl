#version 460
#extension GL_EXT_scalar_block_layout : enable

const float LIGHT_ATTENUATION = 0.9f;
const int MAX_LIGHT_POINT = 32;
// in
layout(location = 0) in vec4 in_color;
layout(location = 1) in vec3 in_normal;
layout(location = 2) in vec3 in_world_pos;
// out
layout(location = 0) out vec4 out_albedo;
layout(location = 1) out vec4 out_normal;
layout(location = 2) out vec4 out_material;
layout(location = 3) out ivec2 out_entity;

struct LightPoint
{
	vec3 pos;
	vec3 color;
	float intensity;
};

// View
layout(std430, set = 3, binding = 0) uniform View
{
	layout(row_major) mat4 mat_view_proj;
	layout(row_major) mat4 mat_inv_view_proj;
	vec3 vec_pos;
} view;
// Model
layout(std430, set = 3, binding = 1) uniform Model
{
	float specular_strength;
	float shininess;
	int entity_id;
} model;

void main()
{
	// out_albedo
	vec4 texel_color = in_color;
	out_albedo = texel_color;
	// out_normal
	vec3 normal_world = normalize(in_normal);
	out_normal = vec4(normal_world, 0.0);
	// out_material
	out_material = ivec4(model.specular_strength, model.shininess, float(model.entity_id), 0.0) + 1;
	// out_entity
	out_entity = ivec2(model.entity_id, 0);
	return;
}
