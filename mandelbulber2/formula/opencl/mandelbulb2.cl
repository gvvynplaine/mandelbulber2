/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Fractal formula created by Buddhi
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

REAL4 Mandelbulb2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	Q_UNUSED(fractal);

	aux->r_dz = aux->r_dz * 2.0f * aux->r;

	REAL temp, tempR;
	tempR = native_sqrt(mad(z.x, z.x, z.y * z.y)); //+ 1e-030f
	z *= native_recip(tempR);
	temp = mad(z.x, z.x, -z.y * z.y);
	z.y = 2.0f * z.x * z.y;
	z.x = temp;
	z *= tempR;

	tempR = native_sqrt(mad(z.y, z.y, z.z * z.z)); //+ 1e-030f
	z *= native_recip(tempR);
	temp = mad(z.y, z.y, -z.z * z.z);
	z.z = 2.0f * z.y * z.z;
	z.y = temp;
	z *= tempR;

	tempR = native_sqrt(mad(z.x, z.x, z.z * z.z)); //+ 1e-030f
	z *= native_recip(tempR);
	temp = mad(z.x, z.x, -z.z * z.z);
	z.z = 2.0f * z.x * z.z;
	z.x = temp;
	z *= tempR;

	z *= aux->r;
	return z;
}