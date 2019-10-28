/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2019 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDifsCylinderIteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the function "TransfDIFSCylinderIteration" in the file fractal_formulas.cpp
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSCylinderIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 oldZ = z;
	z += fractal->transformCommon.offset001;
	REAL4 zc = oldZ;

	REAL cylR = native_sqrt(mad(zc.x, zc.x, zc.y * zc.y)) - fractal->transformCommon.radius1;
	REAL cylH = fabs(zc.z) - fractal->transformCommon.offsetA1;

	cylR = max(cylR, 0.0f);
	cylH = max(cylH, 0.0f);
	REAL cylD = native_sqrt(mad(cylR, cylR, cylH * cylH));
	cylD = min(max(cylR, cylH), 0.0f) + cylD;

	aux->dist = min(aux->dist, native_divide(cylD, aux->DE));
	return z;
}