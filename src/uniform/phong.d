module dulse_preset.uniform.phong;

import dulse.math;

struct UniformScene
{
	Vec4 light_ambient;
}

struct UniformLight
{
	LightPoint[1] light_point_list;
	uint count_light_point = 1;
}

struct LightPoint
{
	Vec4 pos = [0.0f, 0.0f, -3.0f, 0f];
	Vec4 color = [1.0f, 1.0f, 1.0f, 0f];
	float intensity = 1.0f;
}
