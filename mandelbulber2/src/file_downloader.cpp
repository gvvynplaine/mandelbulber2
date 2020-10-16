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
 * Authors: Sebastian Jennen (jenzebas@gmail.com)
 *
 * cFileDownloader class - downloads specified file list
 */

#include "file_downloader.hpp"

#include <QNetworkRequest>

#include "global_data.hpp"
#include "wait.hpp"

cFileDownloader::cFileDownloader(QString sourceBaseURL, QString targetDir) : QObject()
{
	this->sourceBaseURL = sourceBaseURL;
	this->targetDir = targetDir;
	network.reset(new QNetworkAccessManager());
	done = true;
	currentFileFinished = true;
	cntFilesAlreadyExists = 0;
	cntFilesToDownload = 0;
	cntFilesDownloaded = 0;
}

cFileDownloader::~cFileDownloader()
{
	// nothing to delete
}

void cFileDownloader::downloadFileList()
{
	emit updateProgressAndStatus(tr("File downloader"), tr("retrieving file list"), 0.0);

	done = false;
	currentFileFinished = false;
	QNetworkReply *reply = network->get(QNetworkRequest(QUrl(sourceBaseURL + "/filelist.txt")));
	connect(reply, SIGNAL(finished()), this, SLOT(fileListDownloaded()));

	while (!done)
	{
		Wait(100);
		gApplication->processEvents();
	}

	emit updateProgressAndStatus(
		tr("File downloader"), tr("finished, downloaded %1 files").arg(cntFilesDownloaded), 1.0);
}

void cFileDownloader::fileListDownloaded()
{
	// read file list content and determine files to download
	QNetworkReply *replyList = qobject_cast<QNetworkReply *>(sender());
	QString fileListContent = replyList->readAll();
	QStringList tempList = fileListContent.split("\n");

	for (int i = 0; i < tempList.size(); i++)
	{
		QString temp = tempList.at(i).trimmed();
		if (temp == "" || temp.startsWith("#")) continue;
		if (QFile::exists(targetDir + QDir::separator() + temp))
		{
			cntFilesAlreadyExists++;
			continue;
		}
		cntFilesToDownload++;
		filesToDownload.append(temp);
	}

	// process all files to download
	for (int i = 0; i < filesToDownload.size(); i++)
	{
		QString file = filesToDownload.at(i);
		QNetworkReply *replyFile = network->get(QNetworkRequest(QUrl(sourceBaseURL + "/" + file)));

		tempFile.reset(new QFile(targetDir + QDir::separator() + file));
		if (!tempFile->open(QIODevice::WriteOnly))
		{
			qCritical() << "could not open file for writing!" << tempFile->fileName();
		}
		else
		{
			connect(replyFile, SIGNAL(finished()), this, SLOT(fileDownloaded()));
			while (!currentFileFinished)
			{
				Wait(10);
				gApplication->processEvents();
			}
		}
		currentFileFinished = false;
	}
	done = true;
}

void cFileDownloader::fileDownloaded()
{
	// write downloaded data to file and emit progress
	QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
	tempFile->write(reply->readAll());
	tempFile->flush();
	tempFile->close();
	cntFilesDownloaded++;
	QFileInfo fileInfo(tempFile->fileName());

	emit updateProgressAndStatus(tr("File downloader"),
		tr("file %1 downloaded, %2 of %3")
			.arg(fileInfo.fileName(), QString::number(cntFilesDownloaded),
				QString::number(cntFilesToDownload)),
		1.0 * cntFilesDownloaded / cntFilesToDownload);
	currentFileFinished = true;
}
