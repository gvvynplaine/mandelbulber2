/**
 * Mandelbulber v2, a 3D fractal generator       ,=#MKNmMMKmmßMNWy,
 *                                             ,B" ]L,,p%%%,,,§;, "K
 * Copyright (C) 2016-20 Mandelbulber Team     §R-==%w["'~5]m%=L.=~5N
 *                                        ,=mm=§M ]=4 yJKA"/-Nsaj  "Bw,==,,
 * This file is part of Mandelbulber.    §R.r= jw",M  Km .mM  FW ",§=ß., ,TN
 *                                     ,4R =%["w[N=7]J '"5=],""]]M,w,-; T=]M
 * Mandelbulber is free software:     §R.ß~-Q/M=,=5"v"]=Qf,'§"M= =,M.§ Rz]M"Kw
 * you can redistribute it and/or     §w "xDY.J ' -"m=====WeC=\ ""%""y=%"]"" §
 * modify it under the terms of the    "§M=M =D=4"N #"%==A%p M§ M6  R' #"=~.4M
 * GNU General Public License as        §W =, ][T"]C  §  § '§ e===~ U  !§[Z ]N
 * published by the                    4M",,Jm=,"=e~  §  §  j]]""N  BmM"py=ßM
 * Free Software Foundation,          ]§ T,M=& 'YmMMpM9MMM%=w=,,=MT]M m§;'§,
 * either version 3 of the License,    TWw [.j"5=~N[=§%=%W,T ]R,"=="Y[LFT ]N
 * or (at your option)                   TW=,-#"%=;[  =Q:["V""  ],,M.m == ]N
 * any later version.                      J§"mr"] ,=,," =="""J]= M"M"]==ß"
 *                                          §= "=C=4 §"eM "=B:m|4"]#F,§~
 * Mandelbulber is distributed in            "9w=,,]w em%wJ '"~" ,=,,ß"
 * the hope that it will be useful,                 . "K=  ,=RMMMßM"""
 * but WITHOUT ANY WARRANTY;                            .'''
 * without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Mandelbulber. If not, see <http://www.gnu.org/licenses/>.
 *
 * ###########################################################################
 *
 * Authors: Krzysztof Marczak (buddhi1980@gmail.com)
 *
 * cAudioSelector - This is a file selector widget for audio files.
 */

#ifndef MANDELBULBER2_QT_AUDIO_SELECTOR_H_
#define MANDELBULBER2_QT_AUDIO_SELECTOR_H_

#include <memory>

#include <QAudioOutput>
#include <QBuffer>
#include <QMediaPlayer>
#include <QWidget>

// forward declarations
class cAutomatedWidgets;
class cAudioTrack;
class cAnimationFrames;

namespace Ui
{
class cAudioSelector;
}

class cAudioSelector : public QWidget
{
	Q_OBJECT
public:
	explicit cAudioSelector(QWidget *parent = nullptr);
	~cAudioSelector() override;
	void AssignParameter(const QString &_parameterName);
	void AssignAnimation(std::shared_ptr<cAnimationFrames> _animationFrames);

private slots:
	void slotLoadAudioFile();
	void slotAudioLoaded();
	void slotFreqChanged();
	void slotDeleteAudioTrack();
	void slotPlaybackStart() const;
	void slotPlaybackStop();
	void slotSeekTo(int position);
	void slotPlayPositionChanged(bool updateSlider = true);
	void slotPlaybackStateChanged(QAudio::State state) const;
	void slotChangedFrequencyBand(double midFreq, double bandWidth) const;

private:
	void audioSetup();
	void ConnectSignals() const;
	void RenameWidget(QWidget *widget) const;
	void SetStartStopButtonsPlayingStatus(QAudio::State state) const;
	QString FullParameterName(const QString &parameterName) const;

	Ui::cAudioSelector *ui;

	cAutomatedWidgets *automatedWidgets;

	std::shared_ptr<cAudioTrack> audio;
	QString parameterName;
	std::shared_ptr<cAnimationFrames> animationFrames;

	std::unique_ptr<QAudioOutput> audioOutput;
	QByteArray playBuffer;
	std::unique_ptr<QBuffer> playStream;

signals:
	void frequencyChanged(double midfreq, double bandwidth);
	void audioLoaded();
	void loadingProgress(QString progressText);
	void playPositionChanged(qint64 milliseconds);
};

#endif /* MANDELBULBER2_QT_AUDIO_SELECTOR_H_ */
