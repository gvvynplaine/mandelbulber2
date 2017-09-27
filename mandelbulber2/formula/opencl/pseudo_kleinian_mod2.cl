/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Pseudo Kleinian Mod2, Knighty - Theli-at's Pseudo Kleinian (Scale 1 JuliaBox + Something
 * @reference https://github.com/Syntopia/Fragmentarium/blob/master/
 * Fragmentarium-Source/Examples/Knighty%20Collection/PseudoKleinian.frag
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

REAL4 PseudoKleinianMod2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 c = aux->const_c;

	// spherical fold
	if (fractal->transformCommon.functionEnabledSFalse
			&& aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		REAL para = 0.0f;
		REAL paraAddP0 = 0.0f;
		if (fractal->transformCommon.functionEnabledyFalse)
		{
			if (fractal->Cpara.enabledLinear)
			{
				para = fractal->Cpara.para00; // parameter value at iter 0
				REAL temp0 = para;
				REAL tempA = fractal->Cpara.paraA;
				REAL tempB = fractal->Cpara.paraB;
				REAL tempC = fractal->Cpara.paraC;
				REAL lengthAB = fractal->Cpara.iterB - fractal->Cpara.iterA;
				REAL lengthBC = fractal->Cpara.iterC - fractal->Cpara.iterB;
				REAL grade1 = native_divide((tempA - temp0), fractal->Cpara.iterA);
				REAL grade2 = native_divide((tempB - tempA), lengthAB);
				REAL grade3 = native_divide((tempC - tempB), lengthBC);

				// slopes
				if (aux->i < fractal->Cpara.iterA)
				{
					para = temp0 + (aux->i * grade1);
				}
				if (aux->i < fractal->Cpara.iterB && aux->i >= fractal->Cpara.iterA)
				{
					para = mad(grade2, (aux->i - fractal->Cpara.iterA), tempA);
				}
				if (aux->i >= fractal->Cpara.iterB)
				{
					para = mad(grade3, (aux->i - fractal->Cpara.iterB), tempB);
				}

				// Curvi part on "true"
				if (fractal->Cpara.enabledCurves)
				{
					REAL paraAdd = 0.0f;
					REAL paraIt;
					if (lengthAB > 2.0f * fractal->Cpara.iterA) // stop  error, todo fix.
					{
						REAL curve1 = native_divide((grade2 - grade1), (4.0f * fractal->Cpara.iterA));
						REAL tempL = lengthAB - fractal->Cpara.iterA;
						REAL curve2 = native_divide((grade3 - grade2), (4.0f * tempL));
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

		// if (rr < 1e-21f) rr = 1e-21f;
		if (rr < para)
		{
			REAL tglad_factor1 = native_divide(fractal->transformCommon.maxR2d1, para);
			z *= tglad_factor1;
			aux->DE *= tglad_factor1;
			// aux->color += fractal->mandelbox.color.factorSp1;
		}
		else if (rr < fractal->transformCommon.maxR2d1) // fractal->mandelbox.fR2
		{
			REAL tglad_factor2 = native_divide(fractal->transformCommon.maxR2d1, rr);
			z *= tglad_factor2;
			aux->DE *= tglad_factor2;
			// aux->color += fractal->mandelbox.color.factorSp2;
		}
		z -= fractal->mandelbox.offset;
		z *= fractal->transformCommon.scale1;
		aux->DE = mad(aux->DE, fabs(fractal->transformCommon.scale1), fractal->analyticDE.offset0);
	}

	if (fractal->transformCommon.functionEnabledPFalse
			&& aux->i >= fractal->transformCommon.startIterationsP
			&& aux->i < fractal->transformCommon.stopIterationsP1)
	{
		REAL4 gap = fractal->transformCommon.constantMultiplier000;
		z.y = fabs(z.y);
		z.z = fabs(z.z);
		REAL dot1 = (mad(z.x, -SQRT_3_4, z.y * 0.5f)) * fractal->transformCommon.scale;
		REAL t = max(0.0f, dot1);
		z.x -= t * -SQRT_3;
		z.y = fabs(z.y - t);

		if (z.y > z.z)
		{
			REAL temp = z.y;
			z.y = z.z;
			z.z = temp;
		}
		z -= gap * (REAL4){SQRT_3_4, 1.5f, 1.5f, 0.0f};
		// z was pos, now some points neg (ie neg shift)
		if (z.z > z.x)
		{
			REAL temp = z.z;
			z.z = z.x;
			z.x = temp;
		}
		if (z.x > 0.0f)
		{
			z.y = max(0.0f, z.y);
			z.z = max(0.0f, z.z);
		}
	}

	if (fractal->transformCommon.functionEnabledRFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);

	if (fractal->transformCommon.benesiT1EnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsT
			&& aux->i < fractal->transformCommon.stopIterationsT1)
	{
		REAL tempXZ = mad(z.x, SQRT_2_3, -z.z * SQRT_1_3);
		z = (REAL4){
			(tempXZ - z.y) * SQRT_1_2, (tempXZ + z.y) * SQRT_1_2, z.x * SQRT_1_3 + z.z * SQRT_2_3, 0.0f};

		REAL4 tempZ = z;
		REAL tempL = length(tempZ);
		z = fabs(z) * fractal->transformCommon.scale3D222;
		// if (tempL < 1e-21f) tempL = 1e-21f;
		REAL avgScale = native_divide(length(z), tempL);
		aux->r_dz *= avgScale;
		aux->DE = mad(aux->DE, avgScale, 1.0f);

		tempXZ = (z.y + z.x) * SQRT_1_2;

		z = (REAL4){z.z * SQRT_1_3 + tempXZ * SQRT_2_3, (z.y - z.x) * SQRT_1_2,
			z.z * SQRT_2_3 - tempXZ * SQRT_1_3, 0.0f};
		z = z - fractal->transformCommon.offset200;
	}

	if (fractal->transformCommon.functionEnabledxFalse
			&& aux->i >= fractal->transformCommon.startIterationsD
			&& aux->i < fractal->transformCommon.stopIterationsTM1)
	{
		REAL tempXZ = mad(z.x, SQRT_2_3, -z.z * SQRT_1_3);
		z = (REAL4){
			(tempXZ - z.y) * SQRT_1_2, (tempXZ + z.y) * SQRT_1_2, z.x * SQRT_1_3 + z.z * SQRT_2_3, 0.0f};

		REAL4 temp = z;
		REAL tempL = length(temp);
		z = fabs(z) * fractal->transformCommon.scale3D333;
		// if (tempL < 1e-21f) tempL = 1e-21f;
		REAL avgScale = native_divide(length(z), tempL);
		aux->r_dz *= avgScale;
		aux->DE = mad(aux->DE, avgScale, 1.0f);

		z = (fabs(z + fractal->transformCommon.additionConstant111)
				 - fabs(z - fractal->transformCommon.additionConstant111) - z);

		tempXZ = (z.y + z.x) * SQRT_1_2;

		z = (REAL4){z.z * SQRT_1_3 + tempXZ * SQRT_2_3, (z.y - z.x) * SQRT_1_2,
			z.z * SQRT_2_3 - tempXZ * SQRT_1_3, 0.0f};
	}

	REAL k;
	// Pseudo kleinian
	REAL4 cSize = fractal->transformCommon.additionConstant0777;
	if (fractal->transformCommon.functionEnabledAy
			&& aux->i >= fractal->transformCommon.startIterationsC
			&& aux->i < fractal->transformCommon.stopIterationsC)
	{
		REAL4 tempZ = z; //  correct c++ version. non conditional mult 2.0f

		if (z.x > cSize.x) tempZ.x = cSize.x;
		if (z.x < -cSize.x) tempZ.x = -cSize.x;
		if (z.y > cSize.y) tempZ.y = cSize.y;
		if (z.y < -cSize.y) tempZ.y = -cSize.y;
		if (z.z > cSize.z) tempZ.z = cSize.z;
		if (z.z < -cSize.z) tempZ.z = -cSize.z;

		z = mad(tempZ, 2.0f, -z);
		k = max(native_divide(fractal->transformCommon.minR05, dot(z, z)), 1.0f);
		z *= k;
		aux->DE *= k + fractal->analyticDE.tweak005;
	}

	if (fractal->transformCommon.functionEnabledAyFalse
			&& aux->i >= fractal->transformCommon.startIterationsB
			&& aux->i < fractal->transformCommon.stopIterationsB)
	{
		//  variation from openCL  conditional mult 2.0f
		if (z.x > cSize.x) z.x = mad(cSize.x, 2.0f, -z.x);
		if (z.x < -cSize.x) z.x = mad(-cSize.x, 2.0f, -z.x);
		if (z.y > cSize.y) z.y = mad(cSize.y, 2.0f, -z.y);
		if (z.y < -cSize.y) z.y = mad(-cSize.y, 2.0f, -z.y);
		if (z.z > cSize.z) z.z = mad(cSize.z, 2.0f, -z.z);
		if (z.z < -cSize.z) z.z = mad(-cSize.z, 2.0f, -z.z);

		k = max(native_divide(fractal->transformCommon.minR05, dot(z, z)), 1.0f);
		z *= k;
		aux->DE *= k + fractal->analyticDE.tweak005;
	}

	z += fractal->transformCommon.additionConstant000;

	if (fractal->transformCommon.functionEnabledFFalse
			&& aux->i >= fractal->transformCommon.startIterationsF
			&& aux->i < fractal->transformCommon.stopIterationsF)
	{
		z = fabs(z + fractal->transformCommon.offsetA000)
				- fabs(z - fractal->transformCommon.offsetA000) - z;

		if (fractal->transformCommon.functionEnabledFalse
				&& aux->i >= fractal->transformCommon.startIterationsA
				&& aux->i < fractal->transformCommon.stopIterationsA)
		{
			REAL4 limit = fractal->transformCommon.offsetA000;
			REAL4 length = 2.0f * limit;
			REAL4 tgladS = native_recip(length);
			REAL4 Add;
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
	}
	if (fractal->transformCommon.addCpixelEnabledFalse) // symmetrical addCpixel
	{
		REAL4 tempFAB = c;
		if (fractal->transformCommon.functionEnabledx) tempFAB.x = fabs(tempFAB.x);
		if (fractal->transformCommon.functionEnabledy) tempFAB.y = fabs(tempFAB.y);
		if (fractal->transformCommon.functionEnabledz) tempFAB.z = fabs(tempFAB.z);

		tempFAB *= fractal->transformCommon.offsetF000;
		z.x += sign(z.x) * tempFAB.x;
		z.y += sign(z.y) * tempFAB.y;
		z.z += sign(z.z) * tempFAB.z;
	}
	aux->pseudoKleinianDE = fractal->analyticDE.scale1; // pK DE
	// aux->pseudoKleinianZZ = fractal->transformCommon.scale0; // pK z.z * z.z * scale0
	return z;
}