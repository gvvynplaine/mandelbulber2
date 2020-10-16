/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDifsBoxV3Iteration  fragmentarium code, mdifs by knighty (jan 2012)

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_box_v3.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSBoxV3Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	z += fractal->transformCommon.offset000;

	if (fractal->transformCommon.functionEnabledCxFalse) z.x = -fabs(z.x);
	if (fractal->transformCommon.functionEnabledCyFalse) z.y = -fabs(z.y);
	if (fractal->transformCommon.functionEnabledCzFalse) z.z = -fabs(z.z);

	REAL4 zc = z;
	REAL4 boxSize = fractal->transformCommon.additionConstant111;

	// curvy shape
	if (fractal->transformCommon.functionEnabledTFalse
			&& aux->i >= fractal->transformCommon.startIterationsT
			&& aux->i < fractal->transformCommon.stopIterationsT)
	{
		REAL Zxx = zc.x * zc.x;
		REAL Zzz = zc.z * zc.z;
		boxSize.x += Zzz * fractal->transformCommon.constantMultiplier000.x;
		boxSize.y += Zzz * fractal->transformCommon.constantMultiplier000.y;
		boxSize.z += Zxx * fractal->transformCommon.constantMultiplier000.z;
	}

	// uneven box
	if (fractal->transformCommon.functionEnabledMFalse
			&& aux->i >= fractal->transformCommon.startIterationsM
			&& aux->i < fractal->transformCommon.stopIterationsM)
	{
		REAL4 subZ = (REAL4){z.y, z.z, z.x, z.w} * fractal->transformCommon.scale3D000;
		boxSize -= subZ;
	}

	if (fractal->transformCommon.functionEnabledNFalse
			&& aux->i >= fractal->transformCommon.startIterationsN
			&& aux->i < fractal->transformCommon.stopIterationsN)
	{
		REAL k = fractal->transformCommon.angle0;

		if (fractal->transformCommon.functionEnabledAxFalse)
			k *= aux->i + fractal->transformCommon.offset1;

		REAL swap;
		if (!fractal->transformCommon.functionEnabledOFalse)
			swap = zc.x;
		else
			swap = zc.z;

		if (fractal->transformCommon.functionEnabledAzFalse) swap = fabs(swap);

		REAL c = native_cos(k * zc.y);
		REAL s = native_sin(k * zc.y);
		if (!fractal->transformCommon.functionEnabledOFalse)
			zc.x = c * swap + -s * zc.y;
		else
			zc.z = c * swap + -s * zc.y;
		zc.y = s * swap + c * zc.y;
	}

	zc = fabs(zc) - boxSize;
	zc.x = max(zc.x, 0.0f);
	zc.y = max(zc.y, 0.0f);
	zc.z = max(zc.z, 0.0f);
	REAL zcd = length(zc);

	if (!fractal->transformCommon.functionEnabledEFalse)
		aux->dist = min(aux->dist, zcd / (aux->DE + 1.0f));
	else
		aux->dist = min(aux->dist, zcd / (aux->DE + 1.0f)) - fractal->transformCommon.offsetB0;
	return z;
}