/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Quaternion3DE - Quaternion fractal with extended controls
 * @reference http://www.fractalforums.com/3d-fractal-generation
 * /true-3d-mandlebrot-type-fractal/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_quaternion3d.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 Quaternion3dIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	aux->DE = aux->DE * 2.0f * aux->r;
	z = (REAL4){z.x * z.x - z.y * z.y - z.z * z.z, z.x * z.y, z.x * z.z, z.w};

	REAL tempL = length(z);
	z *= fractal->transformCommon.constantMultiplier122;
	// if (tempL < 1e-21f) tempL = 1e-21f;
	REAL4 tempAvgScale = (REAL4){z.x, z.y / 2.0f, z.z / 2.0f, z.w};
	REAL avgScale = length(tempAvgScale) / tempL;
	REAL tempAux = aux->DE * avgScale;
	aux->DE = aux->DE + (tempAux - aux->DE) * fractal->transformCommon.scaleA1;

	if (fractal->transformCommon.rotationEnabled)
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);

	z += fractal->transformCommon.additionConstant000;
	return z;
}