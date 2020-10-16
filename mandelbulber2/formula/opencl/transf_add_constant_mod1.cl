/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Adds c constant to z vector

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_add_constant_mod1.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfAddConstantMod1Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	Q_UNUSED(aux);
	// std offset
	z += fractal->transformCommon.additionConstantA000;
	// polynomial
	if (fractal->transformCommon.functionEnabledBx
			&& aux->i >= fractal->transformCommon.startIterationsX
			&& aux->i < fractal->transformCommon.stopIterationsX)
	{
		REAL4 temp = fractal->transformCommon.additionConstant000;
		REAL4 temp2 = temp * temp;
		REAL4 z2 = z * z * fractal->transformCommon.scaleA1;
		z.x -=
			((temp.x * temp2.x) / (z2.x + temp2.x) - 2.0f * temp.x) * fractal->transformCommon.scale1;
		z.y -=
			((temp.y * temp2.y) / (z2.y + temp2.y) - 2.0f * temp.y) * fractal->transformCommon.scale1;
		z.z -=
			((temp.z * temp2.z) / (z2.z + temp2.z) - 2.0f * temp.z) * fractal->transformCommon.scale1;
	}

	else if (fractal->transformCommon.functionEnabledByFalse
					 && aux->i >= fractal->transformCommon.startIterationsX
					 && aux->i < fractal->transformCommon.stopIterationsX)
	{
		REAL4 temp = fractal->transformCommon.additionConstant000;
		REAL4 temp2 = temp * temp;
		REAL4 z2 = z * z * fractal->transformCommon.scaleA1;

		z.x -= ((temp2.x) / (z2.x + temp2.x) - 2.0f * temp.x)
					 * fractal->transformCommon.scale1; // * sign(z.x);
		z.y -= ((temp2.y) / (z2.y + temp2.y) - 2.0f * temp.y)
					 * fractal->transformCommon.scale1; // * sign(z.y);
		z.z -= ((temp2.z) / (z2.z + temp2.z) - 2.0f * temp.z)
					 * fractal->transformCommon.scale1; // * sign(z.z);
	}
	return z;
}