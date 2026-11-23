module dulse_preset.uniform.phong;

import dulse.math;

struct UniformScene
{
	Vec4 light_ambient;
}

struct UniformLight
{
	uint count = 0;
	LightPoint[] list;

	this(LightPoint[] list...)
	{
		this.list = list;
		this.count = cast(uint) list.length;
		return;
	}
}

struct LightPoint
{
	Vec4 pos = [0.0f, 0.0f, -3.0f, 0f];
	Vec4 color = [1.0f, 1.0f, 1.0f, 1f];
	//float intensity = 1.0f;
}
