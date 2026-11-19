#version 460
#extension GL_EXT_scalar_block_layout : enable

layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

struct Particle
{
	vec3 pos;
	vec3 vec;
};

/*layout(std430, set = 1, binding = 0) buffer ParticleBuffer
{
	Particle[10] list;
} particle;*/

layout(std430, set = 1, binding = 0) buffer ParticleBuffer
{
	Particle[100] list;
} particle;

void main()
{
	if(gl_GlobalInvocationID.x >= particle.list.length())
	{
		return;
	}
	if(gl_GlobalInvocationID.y != 0) return;
	if(gl_GlobalInvocationID.z != 0) return;

	/*for(int count = 0; count < particle.list.length(); count++)
	{
		if(count == gl_GlobalInvocationID.x) continue;
		if(
			distance(
				particle.list[count].pos,
				particle.list[gl_GlobalInvocationID.x].pos
			) > 1.0
		) continue;
		particle.list[gl_GlobalInvocationID.x].vec
		 += normalize(particle.list[gl_GlobalInvocationID.x].pos - particle.list[count].pos)*0.03;
	}*/
	particle.list[gl_GlobalInvocationID.x].vec
	 += normalize(
		vec3(0.0, 0.0, 0.0)
		 - normalize(particle.list[gl_GlobalInvocationID.x].pos)
	)*0.02;
	// move
	particle.list[gl_GlobalInvocationID.x].pos += particle.list[gl_GlobalInvocationID.x].vec*0.02;
	// attenuation
	particle.list[gl_GlobalInvocationID.x].vec *= 1.0;

	return;
}