/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * mandelbulb juliabulb hybrid 3D
 * constructed from Mandelbulb, Msltoe - Julia Bulb Eiffie & Msltoe - Sym4 Mod formulas.
 * note: an Offset Radius of 0.1 can sometimes improve the DE statistic

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_mandelbulb_juliabulb.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MandelbulbJuliabulbIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	// mandelbulb multi
	if (aux->i >= fractal->transformCommon.startIterationsM
			&& aux->i < fractal->transformCommon.stopIterationsM)
	{
		aux->r = length(z);
		if (fractal->transformCommon.functionEnabledFalse)
		{
			if (fractal->transformCommon.functionEnabledAxFalse
					&& aux->i >= fractal->transformCommon.startIterationsX
					&& aux->i < fractal->transformCommon.stopIterationsX)
				z.x = fabs(z.x);
			if (fractal->transformCommon.functionEnabledAyFalse
					&& aux->i >= fractal->transformCommon.startIterationsY
					&& aux->i < fractal->transformCommon.stopIterationsY)
				z.y = fabs(z.y);
			if (fractal->transformCommon.functionEnabledAzFalse
					&& aux->i >= fractal->transformCommon.startIterationsZ
					&& aux->i < fractal->transformCommon.stopIterationsZ)
				z.z = fabs(z.z);
		}

		REAL th0 = fractal->bulb.betaAngleOffset;
		REAL ph0 = fractal->bulb.alphaAngleOffset;

		REAL3 v;
		switch (fractal->sinTan2Trig.orderOfZYX)
		{
			case multi_OrderOfZYXCl_zyx:
			default: v = (REAL3){z.z, z.y, z.x}; break;
			case multi_OrderOfZYXCl_zxy: v = (REAL3){z.z, z.x, z.y}; break;
			case multi_OrderOfZYXCl_yzx: v = (REAL3){z.y, z.z, z.x}; break;
			case multi_OrderOfZYXCl_yxz: v = (REAL3){z.y, z.x, z.z}; break;
			case multi_OrderOfZYXCl_xzy: v = (REAL3){z.x, z.z, z.y}; break;
			case multi_OrderOfZYXCl_xyz: v = (REAL3){z.x, z.y, z.z}; break;
		}

		if (fractal->sinTan2Trig.asinOrAcos == multi_asinOrAcosCl_asin)
			th0 += asin(v.x / aux->r);
		else
			th0 += acos(v.x / aux->r);

		if (fractal->sinTan2Trig.atan2OrAtan == multi_atan2OrAtanCl_atan2)
			ph0 += atan2(v.y, v.z);
		else
			ph0 += atan(v.y / v.z);

		REAL rp = native_powr(aux->r, fractal->bulb.power - 1.0f);
		REAL th = th0 * fractal->bulb.power * fractal->transformCommon.scaleA1;
		REAL ph = ph0 * fractal->bulb.power * fractal->transformCommon.scaleB1;

		aux->DE = rp * aux->DE * fractal->bulb.power + 1.0f;
		rp *= aux->r;

		if (fractal->transformCommon.functionEnabledxFalse)
		{ // cosine mode
			REAL sinth = th;
			if (fractal->transformCommon.functionEnabledyFalse) sinth = th0;
			sinth = native_sin(sinth);
			z = rp * (REAL4){sinth * native_sin(ph), native_cos(ph) * sinth, native_cos(th), 0.0f};
		}
		else
		{ // sine mode
			REAL costh = th;
			if (fractal->transformCommon.functionEnabledzFalse) costh = th0;
			costh = native_cos(costh);
			z = rp * (REAL4){costh * native_cos(ph), native_sin(ph) * costh, native_sin(th), 0.0f};
		}
	}

	// sym4
	if (fractal->transformCommon.functionEnabled
			&& aux->i >= fractal->transformCommon.startIterationsD
			&& aux->i < fractal->transformCommon.stopIterationsD)
	{
		aux->r = length(z);
		aux->DE = aux->DE * 2.0f * aux->r;
		REAL4 temp = z;
		REAL tempL = length(temp);
		// if (tempL < 1e-21f)
		//	tempL = 1e-21f;
		z *= fractal->transformCommon.scale3D111;

		aux->DE *= fabs(length(z) / tempL);

		if (fabs(z.x) < fabs(z.z))
		{
			REAL temp = z.x;
			z.x = z.z;
			z.z = temp;
		}
		if (fabs(z.x) < fabs(z.y))
		{
			REAL temp = z.x;
			z.x = z.y;
			z.y = temp;
		}
		if (fabs(z.y) < fabs(z.z))
		{
			REAL temp = z.y;
			z.y = z.z;
			z.z = temp;
		}

		if (z.x * z.z < 0.0f) z.z = -z.z;
		if (z.x * z.y < 0.0f) z.y = -z.y;

		temp.x = z.x * z.x - z.y * z.y - z.z * z.z;
		temp.y = 2.0f * z.x * z.y;
		temp.z = 2.0f * z.x * z.z;

		z = temp + fractal->transformCommon.offsetF000;
	}

	// sym3 msltoe eiffie
	if (fractal->transformCommon.functionEnabledEFalse
			&& aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
	{
		aux->r = length(z);
		REAL psi = fabs(fmod(atan2(z.z, z.y) + M_PI_F + M_PI_8_F, M_PI_4_F) - M_PI_8_F);
		REAL lengthYZ = native_sqrt(z.y * z.y + z.z * z.z);

		z.y = native_cos(psi) * lengthYZ;
		z.z = native_sin(psi) * lengthYZ;
		aux->DE = aux->DE * 2.0f * aux->r;

		REAL4 z2 = z * z;
		REAL rr = z2.x + z2.y + z2.z;
		REAL m = 1.0f - z2.z / rr;
		REAL4 temp;
		temp.x = (z2.x - z2.y) * m;
		temp.y = 2.0f * z.x * z.y * m * fractal->transformCommon.scale; // scaling y;;
		temp.z = 2.0f * z.z * native_sqrt(z2.x + z2.y);
		temp.w = z.w;
		z = temp + fractal->transformCommon.additionConstant000;
	}

	if (fractal->transformCommon.addCpixelEnabledFalse)
	{
		REAL4 c = aux->const_c;
		REAL4 tempC = c;
		if (fractal->transformCommon.alternateEnabledFalse) // alternate
		{
			tempC = aux->c;
			switch (fractal->mandelbulbMulti.orderOfXYZC)
			{
				case multi_OrderOfXYZCl_xyz:
				default: tempC = (REAL4){tempC.x, tempC.y, tempC.z, tempC.w}; break;
				case multi_OrderOfXYZCl_xzy: tempC = (REAL4){tempC.x, tempC.z, tempC.y, tempC.w}; break;
				case multi_OrderOfXYZCl_yxz: tempC = (REAL4){tempC.y, tempC.x, tempC.z, tempC.w}; break;
				case multi_OrderOfXYZCl_yzx: tempC = (REAL4){tempC.y, tempC.z, tempC.x, tempC.w}; break;
				case multi_OrderOfXYZCl_zxy: tempC = (REAL4){tempC.z, tempC.x, tempC.y, tempC.w}; break;
				case multi_OrderOfXYZCl_zyx: tempC = (REAL4){tempC.z, tempC.y, tempC.x, tempC.w}; break;
			}
			aux->c = tempC;
		}
		else
		{
			switch (fractal->mandelbulbMulti.orderOfXYZC)
			{
				case multi_OrderOfXYZCl_xyz:
				default: tempC = (REAL4){c.x, c.y, c.z, c.w}; break;
				case multi_OrderOfXYZCl_xzy: tempC = (REAL4){c.x, c.z, c.y, c.w}; break;
				case multi_OrderOfXYZCl_yxz: tempC = (REAL4){c.y, c.x, c.z, c.w}; break;
				case multi_OrderOfXYZCl_yzx: tempC = (REAL4){c.y, c.z, c.x, c.w}; break;
				case multi_OrderOfXYZCl_zxy: tempC = (REAL4){c.z, c.x, c.y, c.w}; break;
				case multi_OrderOfXYZCl_zyx: tempC = (REAL4){c.z, c.y, c.x, c.w}; break;
			}
		}
		z += tempC * fractal->transformCommon.constantMultiplierC111;
	}
	// radial offset
	REAL lengthTempZ = -length(z);
	// if (lengthTempZ > -1e-21f)
	//	lengthTempZ = -1e-21f;   //  z is neg.)
	z *= 1.0f + fractal->transformCommon.offset / lengthTempZ;
	// scale
	z *= fractal->transformCommon.scale1;
	aux->DE *= fabs(fractal->transformCommon.scale1);
	return z;
}