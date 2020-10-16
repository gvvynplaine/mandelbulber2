/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * knotv2
 * knot thingy by knighty (2012). Based on an idea by DarkBeam from fractalforums
 *(http://www.fractalforums.com/new-theories-and-research/not-fractal-but-funny-trefoil-knot-routine/30/)

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_knot_v2.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 KnotV2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	if (fractal->transformCommon.functionEnabledAxFalse) z.x = fabs(z.x);
	if (fractal->transformCommon.functionEnabledAyFalse) z.y = fabs(z.y);
	if (fractal->transformCommon.functionEnabledAzFalse) z.z = fabs(z.z);
	z += fractal->transformCommon.offset000;

	REAL4 zc = z;
	REAL tempA = zc.y;
	REAL tempB = zc.z;
	if (fractal->transformCommon.functionEnabledJFalse)
	{
		REAL temp = tempA;
		tempA = tempB;
		tempB = temp;
	}

	zc.z *= fractal->transformCommon.scaleA1;
	REAL rxz = native_sqrt(zc.x * zc.x + tempA * tempA);
	REAL ang = atan2(tempA, zc.x);
	REAL t = tempB;

	REAL colorDist = 0.0f;
	for (int n = 0; n < fractal->transformCommon.int3; n++)
	{
		zc = (REAL4){rxz, t, ang + M_PI_2x_F * n, 0.0f};

		zc.x -= fractal->transformCommon.offsetA2;

		REAL ra =
			zc.z * ((REAL)fractal->transformCommon.int3X) / ((REAL)fractal->transformCommon.int3Z);
		REAL raz =
			zc.z * ((REAL)fractal->transformCommon.int8Y) / ((REAL)fractal->transformCommon.int3Z);

		zc.x =
			zc.x
			- (fractal->transformCommon.offset1 * native_cos(ra) + fractal->transformCommon.offsetA2);
		zc.y =
			zc.y
			- (fractal->transformCommon.offset1 * native_sin(raz) + fractal->transformCommon.offsetA2);

		aux->DE0 = native_sqrt(zc.x * zc.x + zc.y * zc.y) - fractal->transformCommon.offset01;

		if (fractal->transformCommon.functionEnabledKFalse) aux->DE0 /= aux->DE;

		if (!fractal->transformCommon.functionEnabledDFalse)
			aux->dist = min(aux->dist, aux->DE0);
		else
			aux->dist = aux->DE0;
	}
	if (fractal->transformCommon.functionEnabledEFalse) z = zc;

	// aux->color
	if (fractal->foldColor.auxColorEnabled)
	{
		REAL colorAdd = 0.0f;

		if (fmod(ang, 2.0f) < 1.0f) colorAdd += fractal->foldColor.difs0000.x;
		colorAdd += fractal->foldColor.difs0000.y * (zc.x);
		colorAdd += fractal->foldColor.difs0000.z * (zc.y);
		colorAdd += fractal->foldColor.difs0000.w * (zc.z);

		colorAdd += fractal->foldColor.difs1;
		if (fractal->foldColor.auxColorEnabledA)
		{
			if (colorDist != aux->dist) aux->color += colorAdd;
		}
		else
			aux->color += colorAdd;
	}

	// DE tweak
	if (fractal->analyticDE.enabledFalse) aux->dist = aux->dist * fractal->analyticDE.scale1;
	return z;
}