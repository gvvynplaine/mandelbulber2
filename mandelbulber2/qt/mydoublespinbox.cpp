/**
 * Mandelbulber v2, a 3D fractal generator
 *
 * MyDoubleSpinBox class - promoted QDoubleSpinBox widget with context menu
 *
 * Copyright (C) 2014 Krzysztof Marczak
 *
 * This file is part of Mandelbulber.
 *
 * Mandelbulber is free software: you can redistribute it and/or modify it under the terms of the
 * GNU General Public License as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Mandelbulber is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * See the GNU General Public License for more details. You should have received a copy of the GNU
 * General Public License along with Mandelbulber. If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors: Krzysztof Marczak (buddhi1980@gmail.com)
 */

#include "mydoublespinbox.h"
#include <QLineEdit>
#include "../src/animation_flight.hpp"
#include "../src/animation_keyframes.hpp"

void MyDoubleSpinBox::paintEvent(QPaintEvent *event)
{
	if (value() != GetDefault())
	{
		QFont f = font();
		f.setBold(true);
		setFont(f);
	}
	else
	{
		QFont f = font();
		f.setBold(false);
		setFont(f);
	}
	QDoubleSpinBox::paintEvent(event);
}

double MyDoubleSpinBox::GetDefault()
{
	if (parameterContainer && !gotDefault)
	{
		QString type = GetType(objectName());
		if (type == QString("spinbox3") || type == QString("spinboxd3"))
		{
			char lastChar = (parameterName.at(parameterName.length() - 1)).toLatin1();
			QString nameVect = parameterName.left(parameterName.length() - 2);
			CVector3 val = parameterContainer->GetDefault<CVector3>(nameVect);
			defaultValue = val.itemByName(lastChar);
			gotDefault = true;
			setToolTipText();
		}
		else if (type == QString("spinbox4") || type == QString("spinboxd4"))
		{
			char lastChar = (parameterName.at(parameterName.length() - 1)).toLatin1();
			QString nameVect = parameterName.left(parameterName.length() - 2);
			CVector4 val = parameterContainer->GetDefault<CVector4>(nameVect);
			defaultValue = val.itemByName(lastChar);
			gotDefault = true;
			setToolTipText();
		}
		else
		{
			defaultValue = parameterContainer->GetDefault<double>(parameterName);
			gotDefault = true;
			setToolTipText();
		}
	}
	return defaultValue;
}

void MyDoubleSpinBox::resetToDefault()
{
	setValue(defaultValue);
	emit valueChanged(defaultValue);
}

QString MyDoubleSpinBox::getDefaultAsString()
{
	return QString("%L1").arg(defaultValue, 0, 'g', 16);
}

QString MyDoubleSpinBox::getFullParameterName()
{
	QString parName = parameterName;
	QString type = GetType(objectName());
	if (type == QString("spinbox3") || type == QString("spinboxd3") || type == QString("spinbox4")
			|| type == QString("spinboxd4"))
		parName = parameterName.left(parameterName.length() - 2);
	return parName;
}

void MyDoubleSpinBox::contextMenuEvent(QContextMenuEvent *event)
{
	CommonMyWidgetWrapper::contextMenuEvent(event, lineEdit()->createStandardContextMenu());
}
