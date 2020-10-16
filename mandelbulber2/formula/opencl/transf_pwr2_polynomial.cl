/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * z = (Az^2 + Bz + C ) / D; ((VectA +ScaleA * z) * fn(z) + scaleB * z + VectC ) * ScaleD

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_pwr2_polynomial.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfPwr2PolynomialIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 partA = z;
	if (fractal->transformCommon.functionEnabledFalse) // fabs
		partA = fabs(z);
	if (fractal->transformCommon.functionEnabledxFalse) // pwr3 or z * fabs(z^2)
		partA *= z;
	partA = partA * fractal->transformCommon.scale2 + fractal->transformCommon.constantMultiplier111;

	REAL4 fnZ1 = z;
	if (fractal->transformCommon.functionEnabledBxFalse) // native_cos(z*Pi)
	{
		REAL scalePi = M_PI_F * fractal->transformCommon.scaleC1;
		fnZ1.x = native_cos(z.x * scalePi);
		fnZ1.y = native_cos(z.y * scalePi);
		fnZ1.z = native_cos(z.z * scalePi);
	}
	if (fractal->transformCommon.functionEnabledyFalse) // pi rotation
		fnZ1 = RotateAroundVectorByAngle4(fnZ1, fractal->transformCommon.constantMultiplier111.xyz,
			M_PI_F * fractal->transformCommon.scale0);			// * cPI ;
	if (fractal->transformCommon.functionEnabledzFalse) // box offset
	{
		fnZ1.x = fnZ1.x + sign(fnZ1.x) * fractal->transformCommon.additionConstant000.x;
		fnZ1.y = fnZ1.y + sign(fnZ1.y) * fractal->transformCommon.additionConstant000.y;
		fnZ1.z = fnZ1.z + sign(fnZ1.z) * fractal->transformCommon.additionConstant000.z;
	}

	if (fractal->transformCommon.functionEnabledAxFalse) // fabs fnZ1
		fnZ1 = fabs(fnZ1);

	REAL4 partB = z;
	if (fractal->transformCommon.functionEnabledAzFalse) partB = fabs(z);
	partB *= fractal->transformCommon.scale4;

	REAL4 constantMult = (REAL4){fractal->transformCommon.constantMultiplierB111.x,
		fractal->transformCommon.constantMultiplierB111.y,
		fractal->transformCommon.constantMultiplierB111.z, 0.0f};

	z = constantMult + partB - partA * fnZ1;
	z *= fractal->transformCommon.scale025;

	aux->DE = aux->DE * 4.0f * fractal->analyticDE.scale1 + fractal->analyticDE.offset1;
	return z;
}