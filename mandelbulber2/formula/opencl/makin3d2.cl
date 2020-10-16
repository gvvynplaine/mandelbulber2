/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Makin3D-2 found through the another shot at the holy grail topic at ff
 * http://www.fractalgallery.co.uk/ and https://www.facebook.com/david.makin.7
 * @reference http://www.fractalforums.com/3d-fractal-generation/another-shot-at-the-holy-grail/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_makin3d2.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 Makin3d2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	aux->DE = aux->DE * 2.0f * aux->r * fractal->analyticDE.scale1 + fractal->analyticDE.offset1;

	REAL x2 = z.x * z.x;
	REAL y2 = z.y * z.y;
	REAL z2 = z.z * z.z;
	REAL newx = x2 + 2.0f * z.y * z.z;
	REAL newy = -y2 - 2.0f * z.x * z.z;
	REAL newz = -z2 + 2.0f * z.x * z.y;
	z.x = newx;
	z.y = newy;
	z.z = newz;
	return z;
}