/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * poly fold atan2
 * @reference
 * https://fractalforums.org/fragmentarium/17/polyfoldsym-pre-transform/2684

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_poly_fold_atan2.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfPolyFoldAtan2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 oldZ = z;
	// pre abs
	if (fractal->transformCommon.functionEnabledx) z.x = fabs(z.x);
	if (fractal->transformCommon.functionEnabledyFalse) z.y = fabs(z.y);
	if (fractal->transformCommon.functionEnabledzFalse) z.z = fabs(z.z);

	if (fractal->transformCommon.functionEnabledCx)
	{
		if (fractal->transformCommon.functionEnabledAxFalse && z.y < 0.0f) z.x = -z.x;
		int poly = fractal->transformCommon.int8X;
		REAL psi = fabs(fmod(atan2(z.y, z.x) + M_PI_F / poly, M_PI_F / (0.5f * poly)) - M_PI_F / poly);
		REAL len = native_sqrt(z.x * z.x + z.y * z.y);
		z.x = native_cos(psi) * len;
		z.y = native_sin(psi) * len;
	}

	if (fractal->transformCommon.functionEnabledCyFalse)
	{
		if (fractal->transformCommon.functionEnabledAyFalse && z.z < 0.0f) z.y = -z.y;
		int poly = fractal->transformCommon.int8Y;
		REAL psi = fabs(fmod(atan2(z.z, z.y) + M_PI_F / poly, M_PI_F / (0.5f * poly)) - M_PI_F / poly);
		REAL len = native_sqrt(z.y * z.y + z.z * z.z);
		z.y = native_cos(psi) * len;
		z.z = native_sin(psi) * len;
	}

	if (fractal->transformCommon.functionEnabledCzFalse)
	{
		if (fractal->transformCommon.functionEnabledAzFalse && z.x < 0.0f) z.z = -z.z;
		int poly = fractal->transformCommon.int8Z;
		REAL psi = fabs(fmod(atan2(z.x, z.z) + M_PI_F / poly, M_PI_F / (0.5f * poly)) - M_PI_F / poly);
		REAL len = native_sqrt(z.z * z.z + z.x * z.x);
		z.z = native_cos(psi) * len;
		z.x = native_sin(psi) * len;
	}

	// addition constant
	z += fractal->transformCommon.additionConstant000;

	// rotation
	if (fractal->transformCommon.rotation2EnabledFalse)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	// DE tweaks
	if (fractal->analyticDE.enabled)
	{
		if (!fractal->analyticDE.enabledFalse)
			aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
		else
		{
			REAL avgScale = length(z) / length(oldZ);
			aux->DE = aux->DE * avgScale * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
		}
	}
	return z;
}