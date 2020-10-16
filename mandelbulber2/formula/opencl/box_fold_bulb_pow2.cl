/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Hybrid of Mandelbox and Mandelbulb power 2 with scaling of z axis

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_box_fold_bulb_pow2.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 BoxFoldBulbPow2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	(void)aux;
	if (fabs(z.x) > fractal->foldingIntPow.foldFactor)
		z.x = sign(z.x) * fractal->foldingIntPow.foldFactor * 2.0f - z.x;
	if (fabs(z.y) > fractal->foldingIntPow.foldFactor)
		z.y = sign(z.y) * fractal->foldingIntPow.foldFactor * 2.0f - z.y;
	if (fabs(z.z) > fractal->foldingIntPow.foldFactor)
		z.z = sign(z.z) * fractal->foldingIntPow.foldFactor * 2.0f - z.z;

	REAL fR2_2 = 1.0f;
	REAL mR2_2 = 0.25f;
	REAL r2_2 = dot(z, z);
	REAL tglad_factor1_2 = fR2_2 / mR2_2;

	if (r2_2 < mR2_2)
	{
		z = z * tglad_factor1_2;
		aux->DE *= tglad_factor1_2;
	}
	else if (r2_2 < fR2_2)
	{
		REAL tglad_factor2_2 = fR2_2 / r2_2;
		z = z * tglad_factor2_2;
		aux->DE *= tglad_factor2_2;
	}

	z = z * 2.0f;
	REAL x2 = z.x * z.x;
	REAL y2 = z.y * z.y;
	REAL z2 = z.z * z.z;
	REAL temp = 1.0f - z2 / (x2 + y2);
	REAL4 zTemp;
	zTemp.x = (x2 - y2) * temp;
	zTemp.y = 2.0f * z.x * z.y * temp;
	zTemp.z = -2.0f * z.z * native_sqrt(x2 + y2);
	zTemp.w = z.w;
	z = zTemp;
	z.z *= fractal->foldingIntPow.zFactor;
	// analyticDE controls
	if (fractal->analyticDE.enabledFalse)
	{
		aux->DE = (aux->DE + 1.0f) * 5.0f * aux->r * fractal->analyticDE.scale1
								* native_sqrt(fractal->foldingIntPow.zFactor * fractal->foldingIntPow.zFactor + 2.0f
															+ fractal->analyticDE.offset2)
							+ fractal->analyticDE.offset1;
	}
	// INFO remark: changed sequence of operation.
	// adding of C constant was before multiplying by z-factor
	return z;
}