/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Adds Cpixel constant to z vector, scator algebra
 * based on Manuel's math
 * @reference
 * https://luz.izt.uam.mx/drupal/en/fractals/hun
 * @author Manuel Fernandez-Guasti

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_add_cpixel_scator.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfAddCpixelScatorIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 oldZ = z;
	REAL4 tempC = aux->const_c;
	if (fractal->transformCommon.functionEnabledSwFalse)
	{
		REAL temp = tempC.x;
		tempC.x = tempC.z;
		tempC.z = temp;
	}

	REAL4 cc = tempC * tempC;
	REAL4 newC = tempC;
	REAL limitA = fractal->transformCommon.scale0;

	if (fractal->transformCommon.functionEnabledRFalse)
	{
		cc = fabs(tempC);
	}

	// scator algebra
	if (cc.x < limitA)
	{
		REAL temp = 1.0f / cc.x - 1.0f;
		cc.x = temp;
	}

	if (!fractal->transformCommon.functionEnabledFalse)
	{																	// real
		newC.x += (cc.y * cc.z) / cc.x; // all pos
		newC.y *= (1.0f + cc.z / cc.x);
		newC.z *= (1.0f + cc.y / cc.x);
		newC *= fractal->transformCommon.constantMultiplier111;
		if (fractal->transformCommon.functionEnabledSwFalse)
		{
			REAL temp = newC.x;
			newC.x = newC.z;
			newC.z = temp;
		}

		if (!fractal->transformCommon.functionEnabledSFalse)
		{
			z += newC;
		}
		else
		{
			z.x += sign(z.x) * newC.x;
			z.y += sign(z.y) * newC.y;
			z.z += sign(z.z) * newC.z;
		}
	}
	else
	{																	// imaginary
		newC.x += (cc.y * cc.z) / cc.x; // pos
		newC.y *= (1.0f - cc.z / cc.x); // pos  neg
		newC.z *= (1.0f - cc.y / cc.x); // pos  neg
		newC *= fractal->transformCommon.constantMultiplier111;
		if (fractal->transformCommon.functionEnabledy) newC.y = fabs(newC.y);
		if (fractal->transformCommon.functionEnabledz) newC.z = fabs(newC.z);

		if (fractal->transformCommon.functionEnabledSwFalse)
		{
			REAL temp = newC.x;
			newC.x = newC.z;
			newC.z = temp;
		}

		// add Cpixel
		if (!fractal->transformCommon.functionEnabledSFalse)
		{
			z += newC;
		}
		else
		{
			z.x += sign(z.x) * newC.x;
			z.y += sign(z.y) * newC.y;
			z.z += sign(z.z) * newC.z;
		}
	}
	// DE calculations
	if (fractal->analyticDE.enabledFalse)
	{
		REAL vecDE = length(z) / length(oldZ);
		aux->DE = aux->DE * vecDE * fractal->analyticDE.scale1 + fractal->analyticDE.offset1;
	}
	return z;
}