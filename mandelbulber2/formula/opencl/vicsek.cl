/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Vicsek

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_vicsek.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 VicsekIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL colorAdd = 0.0f;
	REAL rrCol = 0.0f;
	REAL4 zCol = z;
	REAL4 oldZ = z;

	// octo
	if (fractal->transformCommon.functionEnabledxFalse
			&& aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
	{
		if (z.x + z.y < 0.0f) z = (REAL4){-z.y, -z.x, z.z, z.w};

		if (z.x + z.z < 0.0f) // z.xz = -z.zx;
			z = (REAL4){-z.z, z.y, -z.x, z.w};

		if (z.x - z.y < 0.0f) // z.xy = z.yx;
			z = (REAL4){z.y, z.x, z.z, z.w};

		if (z.x - z.z < 0.0f) // z.xz = z.zx;
			z = (REAL4){z.z, z.y, z.x, z.w};

		z.x = fabs(z.x);
		z = z * fractal->transformCommon.scale2
				- fractal->transformCommon.offset100 * (fractal->transformCommon.scale2 - 1.0f);

		aux->DE *= fractal->transformCommon.scale2;
	}

	// spherical fold
	if (fractal->transformCommon.functionEnabledSFalse
			&& aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		REAL rr = dot(z, z);
		rrCol = rr; // test ooooooooooooooooooooooooooooooooo
		// if (r2 < 1e-21f) r2 = 1e-21f;
		if (rr < fractal->transformCommon.minR2p25)
		{
			REAL tglad_factor1 = fractal->transformCommon.maxMinR2factor;
			// REAL tglad_factor1 = fractal->transformCommon.maxR2d1 /fractal->transformCommon.minR2p25;
			z *= tglad_factor1;
			aux->DE *= tglad_factor1;
			aux->color += fractal->mandelbox.color.factorSp1;
		}
		else if (rr < fractal->transformCommon.maxR2d1)
		{
			REAL tglad_factor2 = fractal->transformCommon.maxR2d1 / rr;
			z *= tglad_factor2;
			aux->DE *= tglad_factor2;
			aux->color += fractal->mandelbox.color.factorSp2;
		}
		z *= fractal->transformCommon.scale08;
		aux->DE = aux->DE * fabs(fractal->transformCommon.scale08);
	}

	// Vicsek
	if (fractal->transformCommon.functionEnabledM
			&& aux->i >= fractal->transformCommon.startIterationsM
			&& aux->i < fractal->transformCommon.stopIterationsM)
	{
		zCol = z; // test ooooooooooooooooooooooooooooooooo
		z = fabs(z);
		if (z.x - z.y < 0.0f)
		{
			REAL temp = z.y;
			z.y = z.x;
			z.x = temp;
		}
		if (z.x - z.z < 0.0f)
		{
			REAL temp = z.z;
			z.z = z.x;
			z.x = temp;
		}
		if (z.y - z.z < 0.0f)
		{
			REAL temp = z.z;
			z.z = z.y;
			z.y = temp;
		}
		z *= fractal->transformCommon.scale3;
		aux->DE *= fractal->transformCommon.scale3;

		REAL4 limit = fractal->transformCommon.offset111;
		if (z.x > limit.x * 0.5f) z.x -= limit.x * fractal->transformCommon.scaleA1;
		if (z.y > limit.y * 0.5f) z.y -= limit.y;
		if (z.z > limit.z) z.z -= 2.0f * limit.z;
		z.x += fractal->transformCommon.offset0;
		zCol = z; // test ooooooooooooooooooooooooooooooooo
	}

	// 45 rot XY
	if (fractal->transformCommon.functionEnabledXFalse
			&& aux->i >= fractal->transformCommon.startIterations
			&& aux->i < fractal->transformCommon.stopIterations)
	{
		REAL xTemp = SQRT_1_2_F * (z.x - z.y);
		z.y = SQRT_1_2_F * (z.y + z.x);
		z.x = xTemp;
	}

	// iter weight
	if (fractal->transformCommon.functionEnabledFalse)
	{
		REAL4 zA = (aux->i == fractal->transformCommon.intA) ? z : (REAL4){0, 0, 0, 0};
		REAL4 zB = (aux->i == fractal->transformCommon.intB) ? z : (REAL4){0, 0, 0, 0};

		z = (z * fractal->transformCommon.scale1) + (zA * fractal->transformCommon.offsetA0)
				+ (zB * fractal->transformCommon.offsetB0);
		aux->DE *= fractal->transformCommon.scale1;
	}

	// Analytic DE tweak
	if (fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;

	// aux color
	if (fractal->foldColor.auxColorEnabledFalse)
	{
		if (fractal->transformCommon.functionEnabledCxFalse)
		{
			if (zCol.x != oldZ.x)
				colorAdd += fractal->mandelbox.color.factor.x
										* (fabs(zCol.x) - fractal->transformCommon.additionConstant111.x);
			if (zCol.y != oldZ.y)
				colorAdd += fractal->mandelbox.color.factor.y
										* (fabs(zCol.y) - fractal->transformCommon.additionConstant111.y);
			if (zCol.z != oldZ.z)
				colorAdd += fractal->mandelbox.color.factor.z
										* (fabs(zCol.z) - fractal->transformCommon.additionConstant111.z);

			if (rrCol < fractal->transformCommon.maxR2d1)
			{
				if (rrCol < fractal->transformCommon.minR2p25)
					colorAdd +=
						fractal->mandelbox.color.factorSp1 * (fractal->transformCommon.minR2p25 - rrCol)
						+ fractal->mandelbox.color.factorSp2
								* (fractal->transformCommon.maxR2d1 - fractal->transformCommon.minR2p25);
				else
					colorAdd +=
						fractal->mandelbox.color.factorSp2 * (fractal->transformCommon.maxR2d1 - rrCol);
			}
		}
		else
		{
			if (zCol.x != oldZ.x) colorAdd += fractal->mandelbox.color.factor.x;
			if (zCol.y != oldZ.y) colorAdd += fractal->mandelbox.color.factor.y;
			if (zCol.z != oldZ.z) colorAdd += fractal->mandelbox.color.factor.z;

			if (rrCol < fractal->transformCommon.minR2p25)
				colorAdd += fractal->mandelbox.color.factorSp1;
			else if (rrCol < fractal->transformCommon.maxR2d1)
				colorAdd += fractal->mandelbox.color.factorSp2;
		}
		aux->color += colorAdd;
	}
	return z;
}