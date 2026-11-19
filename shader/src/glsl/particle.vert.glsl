#version 460
#extension GL_EXT_scalar_block_layout : enable

// input
layout(location = 0) in vec3 in_pos;
layout(location = 1) in vec3 in_normal;
layout(location = 2) in vec2 in_uv;
// out
layout(location = 0) out vec2 out_uv;
layout(location = 1) out vec3 out_normal;
layout(location = 2) out vec3 out_pos;
struct Particle
{
	vec3 pos;
	vec3 vel;
};

/*
vec3 particle_corner[6] = vec3[6](
	vec3(0.0, +1.0, 0.0),
	vec3(-1.0, 0.0, 0.0),
	vec3(0.0, 0.0, -1.0),
	vec3(+1.0, 0.0, 0.0),
	vec3(0.0, 0.0, +1.0),
	vec3(0.0, -1.0, 0.0)
);
uint particle_index[3*8] = uint[3*8](
	0,1,2,0,2,3,0,3,4,0,4,1,
	5,1,2,5,2,3,5,3,4,5,4,1
);
*/

// storage
layout(std430, set = 0, binding = 0) readonly buffer ParticleData
{
	Particle[100] list;
} particle;
// uniform
layout(std430, set = 1, binding = 0) uniform Scene
{
	int elapsed_time;
} scene;

layout(std430, set = 1, binding = 1) uniform View
{
	mat4 mat_view_proj;
} view;

// def
vec3 particle_pos(in uint id);
uint hash(uint arg);
float hash_float(in uint arg);

void main()
{
	// uv
	out_uv = in_uv;
	// normal
	//out_normal = normalize(in_normal * mat3(model.matrix_normal));
	out_normal = in_normal;
	// position
	vec3 world_pos = particle.list[uint(gl_InstanceIndex)].pos + in_pos;
	out_pos = world_pos;
	gl_Position = vec4(world_pos, 1.0f)  * view.mat_view_proj;
		
	return;
}

vec3 particle_pos(in uint id)
{
	return vec3(
		hash_float(id * 3u + 0u),
		hash_float(id * 3u + 1u),
		hash_float(id * 3u + 2u)
	);
}
// hash easily and carelessly
uint hash(uint arg)
{
	/*arg ^= arg >> 16;
	arg *= 0x12345678u;
	arg ^= arg >> 15;
	arg += 0x90123456u;
	arg ^= arg >> 16;*/

	arg ^= arg >> 16;
    arg *= 0x7feb352du;
    arg ^= arg >> 15;
    arg *= 0x846ca68bu;
    arg ^= arg >> 16;
	return arg;
}

float hash_float(in uint arg)
{
	return float(hash(arg) >> 8) / float(1 << 24);
}