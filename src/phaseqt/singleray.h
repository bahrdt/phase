/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/qtgui/singleray.h */
/*  Date      : <15 Jul 11 14:16:20 flechsig>  */
/*  Time-stamp: <28 Aug 14 16:41:25 flechsig>  */
/*  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */

// ******************************************************************************
//
//   Copyright (C) 2014 Helmholtz-Zentrum Berlin, Germany and 
//                      Paul Scherrer Institut Villigen, Switzerland
//   
//   Author Johannes Bahrdt, johannes.bahrdt@helmholtz-berlin.de
//          Uwe Flechsig,    uwe.flechsig@psi.ch
//
// ------------------------------------------------------------------------------
//
//   This file is part of PHASE.
//
//   PHASE is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, version 3 of the License, or
//   (at your option) any later version.
//
//   PHASE is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with PHASE (src/LICENSE).  If not, see <http://www.gnu.org/licenses/>. 
//
// ******************************************************************************

//
// this SingleRay class defines the SingleRay widget
//

#ifndef SINGLERAY_H
#define SINGLERAY_H

#if (QT_VERSION < 0x050000)
#include <QtGui>
#else
#include <QtWidgets>
#endif

#include <QLabel>
#include <QLineEdit>
#include <QPushButton>

#include "phaseqt.h"

class SingleRay : public QWidget
{
    Q_OBJECT
    
    struct RayType rayin, rayout;

public:
    QWidget     *singleRayBox;
    SingleRay(PhaseQt *, QWidget *);
    ~SingleRay();

private slots:
    void defaultSlot();
    void applySlot();
    void quitSlot();

private:
    QLabel      *S1Label;        // source box
    QLabel      *S2Label;
    QLabel      *S3Label;
    QLabel      *S4Label;
    QLabel      *S5Label;
    QLabel      *S6Label;
    QLabel      *S7Label;
    QLabel      *S8Label;
    QLabel      *S9Label;
    QLabel      *S10Label;
    QLineEdit   *S1E;
    QLineEdit   *S2E;
    QLineEdit   *S3E;
    QLineEdit   *S4E;
    QLineEdit   *S5E;
    QPushButton *sourceDefaultB;
    QPushButton *sourceApplyB;
    QPushButton *sourceQuitB;
    //    struct BeamlineType  *myparent;
    void        RayTraceSingleRayCpp(PhaseQt *);

    PhaseQt *myparent;
       
};
#endif
