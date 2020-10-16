/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * benesi T2
 * @reference
 * http://www.fractalforums.com/new-theories-and-research/
 * do-m3d-formula-have-to-be-distance-estimation-formulas/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_benesi_t2.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfBenesiT2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL tempXZ = z.x * SQRT_2_3_F - z.z * SQRT_1_3_F;
	z = (REAL4){(tempXZ - z.y) * SQRT_1_2_F, (tempXZ + z.y) * SQRT_1_2_F,
		z.x * SQRT_1_3_F + z.z * SQRT_2_3_F, z.w};

	REAL4 tempV2 = z;
	tempV2.x = native_sqrt(z.y * z.y + z.z * z.z);
	tempV2.y = native_sqrt(z.x * z.x + z.z * z.z); // switching, squared, sqrt
	tempV2.z = native_sqrt(z.x * z.x + z.y * z.y);

	z = fabs(tempV2 - fractal->transformCommon.additionConstant111);

	REAL4 temp = z;
	REAL tempL = length(temp);
	z = fabs(z) * fractal->transformCommon.scale3D444;
	// if (tempL < 1e-21f) tempL = 1e-21f;
	REAL avgScale = length(z) / tempL;
	aux->DE = aux->DE * avgScale + 1.0f;

	if (fractal->transformCommon.rotationEnabled)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	tempXZ = (z.y + z.x) * SQRT_1_2_F;
	z = (REAL4){z.z * SQRT_1_3_F + tempXZ * SQRT_2_3_F, (z.y - z.x) * SQRT_1_2_F,
		z.z * SQRT_2_3_F - tempXZ * SQRT_1_3_F, z.w};
	return z;
}