/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Menger Smooth Mod1, based on :
 * http://www.fractalforums.com/fragmentarium/help-t22583/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_menger_smooth_mod1.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MengerSmoothMod1Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	if (fractal->transformCommon.functionEnabled)
	{
		z = (REAL4){native_sqrt(z.x * z.x + fractal->transformCommon.offset0),
			native_sqrt(z.y * z.y + fractal->transformCommon.offset0),
			native_sqrt(z.z * z.z + fractal->transformCommon.offset0), z.w};
	}
	if (fractal->transformCommon.functionEnabledFFalse)
	{
		z = fabs(z);
		REAL s = fractal->transformCommon.offset;
		z += (REAL4){s, s, s, 0.0f};
	}

	REAL t;
	REAL ScaleP5 = fractal->transformCommon.scale05;
	REAL4 OffsetC = fractal->transformCommon.constantMultiplier221;
	REAL OffsetS = fractal->transformCommon.offset0005;

	t = z.x - z.y;
	t =
		ScaleP5 * (t - native_sqrt(t * t + OffsetS * fractal->transformCommon.constantMultiplier111.x));
	z.x = z.x - t;
	z.y = z.y + t;

	t = z.x - z.z;
	t =
		ScaleP5 * (t - native_sqrt(t * t + OffsetS * fractal->transformCommon.constantMultiplier111.y));
	z.x = z.x - t;
	z.z = z.z + t;

	t = z.y - z.z;
	t =
		ScaleP5 * (t - native_sqrt(t * t + OffsetS * fractal->transformCommon.constantMultiplier111.z));
	z.y = z.y - t;
	z.z = z.z + t;

	z.z = z.z - OffsetC.z / 3.0f;
	z.z = -native_sqrt(z.z * z.z + OffsetS);
	z.z = z.z + OffsetC.z / 3.0f;

	z.x = fractal->transformCommon.scale3 * z.x - OffsetC.x;
	z.y = fractal->transformCommon.scale3 * z.y - OffsetC.y;
	z.z = fractal->transformCommon.scale3 * z.z;

	aux->DE *= fractal->transformCommon.scale3;

	if (fractal->transformCommon.rotationEnabled
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	if (fractal->transformCommon.functionEnabledxFalse
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA) // box offset
	{
		z.x = sign(z.x) * fractal->transformCommon.additionConstantA000.x + z.x;
		z.y = sign(z.y) * fractal->transformCommon.additionConstantA000.y + z.y;
		z.z = sign(z.z) * fractal->transformCommon.additionConstantA000.z + z.z;
	}

	if (fractal->transformCommon.functionEnabledzFalse)
	{
		REAL4 zA = (aux->i == fractal->transformCommon.intA) ? z : (REAL4){0, 0, 0, 0};
		REAL4 zB = (aux->i == fractal->transformCommon.intB) ? z : (REAL4){0, 0, 0, 0};

		z = (z * fractal->transformCommon.scale1) + (zA * fractal->transformCommon.offsetA0)
				+ (zB * fractal->transformCommon.offsetB0);
		aux->DE *= fractal->transformCommon.scale1;
	}
	return z;
}