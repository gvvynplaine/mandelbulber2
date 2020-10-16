/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Benesi Sphere to Cube transform
 * Warps a sphere to a cube; transform made by M.Benesi, optimized by
 * Luca.  Scavenged and edited from code optimized by Luca.
 * @reference http://www.fractalforums.com/mathematics/circle2square/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_benesi_sphere_cube.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfBenesiSphereCubeIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	Q_UNUSED(fractal);
	REAL4 oldZ = z;
	z *= z;
	// if (z.z == 0.0f) z.z = 1e-21f;
	REAL rCyz = z.y / z.z;
	if (rCyz < 1.0f)
		rCyz = 1.0f / native_sqrt(rCyz + 1.0f);
	else
		rCyz = 1.0f / native_sqrt(1.0f / rCyz + 1.0f);

	z.y *= rCyz;
	z.z *= rCyz;

	// if (z.x == 0.0f) z.x = 1e-21f;
	REAL rCxyz = (z.y * z.y + z.z * z.z) / z.x;

	if (rCxyz < 1.0f)
		rCxyz = 1.0f / native_sqrt(rCxyz + 1.0f);
	else
		rCxyz = 1.0f / native_sqrt(1.0f / rCxyz + 1.0f);

	z *= rCxyz * SQRT_3_2_F;
	// aux->DE *= length(z) / length(oldZ);
	if (fractal->analyticDE.enabled)
	{
		aux->DE =
			aux->DE * fractal->analyticDE.scale1 * length(z) / length(oldZ) + fractal->analyticDE.offset1;
	}
	return z;
}