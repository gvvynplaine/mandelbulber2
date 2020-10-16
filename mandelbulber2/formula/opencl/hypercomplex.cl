/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * 3D Mandelbrot formula invented by David Makin
 * http://www.fractalgallery.co.uk/ and https://www.facebook.com/david.makin.7
 * @reference
 *
 http://www.fractalforums.com/3d-fractal-generation/true-3d-mandlebrot-type-fractal/msg7235/#msg7235

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_hypercomplex.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 HypercomplexIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	Q_UNUSED(fractal);

	aux->DE = aux->DE * 2.0f * aux->r;
	REAL newx = z.x * z.x - z.y * z.y - z.z * z.z - z.w * z.w;
	REAL newy = 2.0f * z.x * z.y - 2.0f * z.w * z.z;
	REAL newz = 2.0f * z.x * z.z - 2.0f * z.y * z.w;
	REAL neww = 2.0f * z.x * z.w - 2.0f * z.y * z.z;
	z.x = newx;
	z.y = newy;
	z.z = newz;
	z.w = neww;
	return z;
}