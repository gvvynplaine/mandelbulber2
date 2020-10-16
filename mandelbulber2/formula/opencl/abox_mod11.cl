/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * ABoxMod11,
 * The Mandelbox fractal known as AmazingBox or ABox, invented by Tom Lowe in 2010
 * Variations from DarkBeam, Buddhi, Eiffie and mclarekin
 * based on DarkBeam's Mandelbulb3D code
 * @reference
 * http://www.fractalforums.com/ifs-iterated-function-systems/amazing-fractal/msg12467/#msg12467
 * This formula contains aux.color and aux.actualScale

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_abox_mod11.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 AboxMod11Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL colorAdd = 0.0f;
	aux->actualScale =
		fractal->mandelbox.scale + fractal->mandelboxVary4D.scaleVary * (fabs(aux->actualScale) - 1.0f);
	REAL4 c = aux->const_c;

	// tglad fold
	REAL4 oldZ = z;
	if (aux->i >= fractal->transformCommon.startIterationsB
			&& aux->i < fractal->transformCommon.stopIterationsB)
	{
		z.x = fabs(z.x + fractal->transformCommon.additionConstant111.x)
					- fabs(z.x - fractal->transformCommon.additionConstant111.x) - z.x;
		z.y = fabs(z.y + fractal->transformCommon.additionConstant111.y)
					- fabs(z.y - fractal->transformCommon.additionConstant111.y) - z.y;
		if (fractal->transformCommon.functionEnabled)
		{
			z.z = fabs(z.z + fractal->transformCommon.additionConstant111.z)
						- fabs(z.z - fractal->transformCommon.additionConstant111.z) - z.z;
		}

		if (z.x != oldZ.x) colorAdd += fractal->mandelbox.color.factor.x;
		if (z.y != oldZ.y) colorAdd += fractal->mandelbox.color.factor.y;
		if (z.z != oldZ.z) colorAdd += fractal->mandelbox.color.factor.z;
	}
	if (fractal->transformCommon.functionEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsD
			&& aux->i < fractal->transformCommon.stopIterationsD1)
	{
		REAL4 limit = fractal->transformCommon.additionConstant111;
		REAL4 length = 2.0f * limit;
		REAL4 tgladS = 1.0f / length;
		REAL4 Add = (REAL4){0.0f, 0.0f, 0.0f, 0.0f};
		if (fabs(z.x) < limit.x) Add.x = z.x * z.x * tgladS.x;
		if (fabs(z.y) < limit.y) Add.y = z.y * z.y * tgladS.y;
		if (fabs(z.z) < limit.z) Add.z = z.z * z.z * tgladS.z;
		if (fabs(z.x) > limit.x && fabs(z.x) < length.x)
			Add.x = (length.x - fabs(z.x)) * (length.x - fabs(z.x)) * tgladS.x;
		if (fabs(z.y) > limit.y && fabs(z.y) < length.y)
			Add.y = (length.y - fabs(z.y)) * (length.y - fabs(z.y)) * tgladS.y;
		if (fabs(z.z) > limit.z && fabs(z.z) < length.z)
			Add.z = (length.z - fabs(z.z)) * (length.z - fabs(z.z)) * tgladS.z;
		Add *= fractal->transformCommon.scale3D000;
		z.x = (z.x - (sign(z.x) * (Add.x)));
		z.y = (z.y - (sign(z.y) * (Add.y)));
		z.z = (z.z - (sign(z.z) * (Add.z)));
	}
	// swap
	if (fractal->transformCommon.functionEnabledSwFalse)
	{
		z = (REAL4){z.z, z.y, z.x, z.w};
	}

	// spherical fold
	if (aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		REAL para = 0.0f;
		REAL paraAddP0 = 0.0f;
		if (fractal->transformCommon.functionEnabledyFalse)
		{
			// para += paraAddP0 + fractal->transformCommon.minR2p25;
			if (fractal->Cpara.enabledLinear)
			{
				para = fractal->Cpara.para00; // parameter value at iter 0
				REAL temp0 = para;
				REAL tempA = fractal->Cpara.paraA;
				REAL tempB = fractal->Cpara.paraB;
				REAL tempC = fractal->Cpara.paraC;
				REAL lengthAB = fractal->Cpara.iterB - fractal->Cpara.iterA;
				REAL lengthBC = fractal->Cpara.iterC - fractal->Cpara.iterB;
				REAL grade1 = (tempA - temp0) / fractal->Cpara.iterA;
				REAL grade2 = (tempB - tempA) / lengthAB;
				REAL grade3 = (tempC - tempB) / lengthBC;

				// slopes
				if (aux->i < fractal->Cpara.iterA)
				{
					para = temp0 + (aux->i * grade1);
				}
				if (aux->i < fractal->Cpara.iterB && aux->i >= fractal->Cpara.iterA)
				{
					para = tempA + (aux->i - fractal->Cpara.iterA) * grade2;
				}
				if (aux->i >= fractal->Cpara.iterB)
				{
					para = tempB + (aux->i - fractal->Cpara.iterB) * grade3;
				}

				// Curvi part on "true"
				if (fractal->Cpara.enabledCurves)
				{
					REAL paraAdd = 0.0f;
					REAL paraIt;
					if (lengthAB > 2.0f * fractal->Cpara.iterA) // stop  error, todo fix.
					{
						REAL curve1 = (grade2 - grade1) / (4.0f * fractal->Cpara.iterA);
						REAL tempL = lengthAB - fractal->Cpara.iterA;
						REAL curve2 = (grade3 - grade2) / (4.0f * tempL);
						if (aux->i < 2 * fractal->Cpara.iterA)
						{
							paraIt = tempA - fabs(tempA - aux->i);
							paraAdd = paraIt * paraIt * curve1;
						}
						if (aux->i >= 2 * fractal->Cpara.iterA && aux->i < fractal->Cpara.iterB + tempL)
						{
							paraIt = tempB - fabs(tempB * aux->i);
							paraAdd = paraIt * paraIt * curve2;
						}
						para += paraAdd;
					}
				}
			}
			paraAddP0 = 0.0f;
			if (fractal->Cpara.enabledParabFalse)
			{ // parabolic = paraOffset + iter *slope + (iter *iter *scale)
				paraAddP0 = fractal->Cpara.parabOffset0 + (aux->i * fractal->Cpara.parabSlope)
										+ (aux->i * aux->i * 0.001f * fractal->Cpara.parabScale);
			}
		}
		para += paraAddP0 + fractal->transformCommon.minR2p25;
		// spherical fold
		REAL rr = dot(z, z);

		z += fractal->mandelbox.offset;

		// if (r2 < 1e-21f) r2 = 1e-21f;
		if (rr < para)
		{
			REAL tglad_factor1 = fractal->transformCommon.maxR2d1 / para;
			z *= tglad_factor1;
			aux->DE *= tglad_factor1;
			colorAdd += fractal->mandelbox.color.factorSp1;
		}
		else if (rr < fractal->transformCommon.maxR2d1)
		{
			REAL tglad_factor2 = fractal->transformCommon.maxR2d1 / rr;
			z *= tglad_factor2;
			aux->DE *= tglad_factor2;
			colorAdd += fractal->mandelbox.color.factorSp2;
		}
		z -= fractal->mandelbox.offset;
	}

	// scale, incl DarkBeam's Scale vary
	if (aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		z *= aux->actualScale;

		if (!fractal->analyticDE.enabledFalse)
			aux->DE = aux->DE * fabs(aux->actualScale) + 1.0f;
		else
			aux->DE =
				aux->DE * fabs(aux->actualScale) * fractal->analyticDE.scale1 + fractal->analyticDE.offset1;
	}
	// offset
	z += fractal->transformCommon.additionConstant000;

	// addCpixel
	if (fractal->transformCommon.addCpixelEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
	{
		REAL4 tempC = c;
		if (fractal->transformCommon.alternateEnabledFalse) // alternate
		{
			tempC = aux->c;
			switch (fractal->mandelbulbMulti.orderOfXYZ)
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
			switch (fractal->mandelbulbMulti.orderOfXYZ)
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
		z += tempC * fractal->transformCommon.constantMultiplier111;
	}
	// rotation
	if (fractal->transformCommon.rotationEnabled
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}
	// tweak scale
	if (aux->i >= fractal->transformCommon.startIterationsC
			&& aux->i < fractal->transformCommon.stopIterationsC1)
	{
		z *= fractal->transformCommon.scaleG1;
		aux->DE = aux->DE * fabs(fractal->transformCommon.scaleG1);
	}

	// color updated v2.14
	if (fractal->foldColor.auxColorEnabled)
	{
		aux->color += colorAdd;
	}
	return z;
}