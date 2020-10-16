/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDIFSTorusGridIteration
 * based on http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_torus_grid.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSTorusGridIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 zc = z;

	if (fractal->transformCommon.rotationEnabled)
	{
		zc = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, zc);
	}

	zc.z /= fractal->transformCommon.scaleF1;

	REAL size = fractal->transformCommon.offset2;

	if (!fractal->transformCommon.functionEnabledGFalse)
	{
		zc.x = fabs(zc.x - size * floor(zc.x / size + 0.5f));
		zc.y = fabs(zc.y - size * floor(zc.y / size + 0.5f));
	}
	else
	{
		REAL tx = fractal->transformCommon.int3X;
		REAL ty = fractal->transformCommon.int3Y;
		zc.x = zc.x - size * clamp(round(zc.x / size), -tx, tx);
		zc.y = zc.y - size * clamp(round(zc.y / size), -ty, ty);
	}

	REAL torD = native_sqrt(zc.y * zc.y + zc.x * zc.x) - fractal->transformCommon.offsetT1;

	if (!fractal->transformCommon.functionEnabledJFalse)
		torD = native_sqrt(torD * torD + zc.z * zc.z);
	else
		torD = max(fabs(torD), fabs(zc.z));

	aux->dist = min(aux->dist, torD - fractal->transformCommon.offset0005 / (aux->DE + 1.0f));
	return z;
}