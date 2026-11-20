module dulse_preset.uniform.defer_texture;

import dulse.math;

struct UniformView
{
	Matrix!(4, 4, float) mat_view_proj;
	Matrix!(4, 4, float) mat_inv_view_proj;
	align(16) Vec3 vec_pos;

	this(
		Matrix!(4, 4, float) mat_view,
		Matrix!(4, 4, float) mat_proj,
		Vec3 vec_pos,
	)
	{
		this.vec_pos = vec_pos;
		this.mat_view_proj = mat_view * mat_proj;
		this.mat_inv_view_proj = (mat_view * mat_proj).invert;
		return;
	}
}

struct UniformModelVert
{
	Matrix!(4, 4, float) matrix_model;
	Matrix!(4, 4, float) matrix_model_normal;

	this(Matrix!(4, 4, float) matrix_model)
	{
		this.matrix_model = matrix_model;
		this.matrix_model_normal = matrix_model.to_normal();
		return;
	}
}

struct UniformModelFrag
{
	float specular_strength;
	float shininess;
	int entity_id;
}

Matrix!(4, 4, float) to_normal(Matrix!(4, 4, float) matrix)
{
	return cast(Matrix!(4, 4, float))(cast(Matrix!(3, 3, float)) matrix)
		.invert()
		.transpose();
}