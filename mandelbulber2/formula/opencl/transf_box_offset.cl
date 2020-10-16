/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Box Offset, set different offset for each axis, added symmetrically about the origin
 * will cause cuts along axis

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_box_offset.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfBoxOffsetIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 temp = z;
	z.x = sign(z.x) * fractal->transformCommon.additionConstant000.x + z.x;
	z.y = sign(z.y) * fractal->transformCommon.additionConstant000.y + z.y;
	z.z = sign(z.z) * fractal->transformCommon.additionConstant000.z + z.z;

	if (fractal->transformCommon.functionEnabledFalse)
	{
		REAL tempL = length(temp);
		// if (tempL < 1e-21f) tempL = 1e-21f;
		REAL avgScale = length(z) / tempL;
		aux->DE = aux->DE * avgScale + 1.0f;
	}
	return z;
}