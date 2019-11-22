//  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseqt/singleray.cpp
//  Date      : <26 Jul 11 12:52:43 flechsig> 
//  Time-stamp: <01 May 15 11:55:23 flechsig> 
//  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

//  $Source$ 
//  $Date$
//  $Revision$ 
//  $Author$ 

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
// implementation of the SingleRay class (SingleRay widget)
//
#if (QT_VERSION < 0x050000)
#include <QtGui>
#else
#include <QtWidgets>
#endif

#include "singleray.h"

using namespace std;   // fuer cout z.B.

// constructor
SingleRay::SingleRay(PhaseQt *parent, QWidget *pw)
{
  singleRayBox = new QWidget();

  QGroupBox   *sourceParsGroup  = new QGroupBox(tr("single Ray trace "));
  QGridLayout *sourceParsLayout = new QGridLayout;

  S1Label  = new QLabel(tr("y (mm)"));
  S2Label  = new QLabel(tr("z (mm)"));
  S3Label  = new QLabel(tr("dy (mrad)"));
  S4Label  = new QLabel(tr("dz (mrad)"));
  S5Label  = new QLabel(tr("phi (deg.)"));
  S6Label  = new QLabel(tr("-> 0.0"));
  S7Label  = new QLabel(tr("-> 0.0"));
  S8Label  = new QLabel(tr("-> 0.0"));
  S9Label  = new QLabel(tr("-> 0.0"));
  S10Label = new QLabel(tr("-> 0.0"));
  S1E      = new QLineEdit;
  S2E      = new QLineEdit;
  S3E      = new QLineEdit;
  S4E      = new QLineEdit;
  S5E      = new QLineEdit;
  
  sourceDefaultB = new QPushButton(tr("&Defaults"));
  sourceApplyB   = new QPushButton(tr("&Apply"));
  sourceQuitB    = new QPushButton(tr("&Quit"));

  sourceParsLayout->addWidget(S1Label, 0,0);
  sourceParsLayout->addWidget(S2Label, 1,0);
  sourceParsLayout->addWidget(S3Label, 2,0);
  sourceParsLayout->addWidget(S4Label, 3,0);
  sourceParsLayout->addWidget(S5Label, 4,0);
  sourceParsLayout->addWidget(S6Label, 0,2);
  sourceParsLayout->addWidget(S7Label, 1,2);
  sourceParsLayout->addWidget(S8Label, 2,2);
  sourceParsLayout->addWidget(S9Label, 3,2);
  sourceParsLayout->addWidget(S10Label,4,2);
  sourceParsLayout->addWidget(S1E,     0,1);
  sourceParsLayout->addWidget(S2E,     1,1);
  sourceParsLayout->addWidget(S3E,     2,1);
  sourceParsLayout->addWidget(S4E,     3,1);
  sourceParsLayout->addWidget(S5E,     4,1);
  sourceParsLayout->addWidget(sourceDefaultB, 0, 3);
  sourceParsLayout->addWidget(sourceApplyB,   1, 3);
  sourceParsLayout->addWidget(sourceQuitB,    4, 3);
  sourceParsGroup->setLayout(sourceParsLayout);
  QVBoxLayout *vbox = new QVBoxLayout;
  vbox->addWidget(sourceParsGroup);
  singleRayBox->setLayout(vbox);

  connect(sourceDefaultB, SIGNAL(clicked()), this,  SLOT(defaultSlot()));
  connect(sourceApplyB,   SIGNAL(clicked()), this,  SLOT(applySlot()));
  //connect(sourceQuitB,    SIGNAL(clicked()), this,  SLOT(close()));
  connect(sourceQuitB,    SIGNAL(clicked()), this,  SLOT(quitSlot()));
  // does not work singleRayBox->setAttribute( Qt::WA_DeleteOnClose, true );              // delete on close
  singleRayBox->show();
  this->myparent= parent;
  this->defaultSlot();   // initialize fields with defaults

#ifdef DEBUG
  printf("debug: SingleRay: constructor called, file: %s, line: %d\n", __FILE__,  __LINE__);
#endif
} // constructor

// destructor
SingleRay::~SingleRay()
{
#ifdef DEBUG
  printf("debug: SingleRay destructor called, file: %s, line: %d\n", __FILE__, __LINE__);
#endif
} // destructor


void SingleRay::applySlot()
{
  QString qst;
  
#ifdef DEBUG
  cout << "debug: applySlot called" << endl;
#endif

  rayin.y  = S1E->text().toDouble();
  rayin.z  = S2E->text().toDouble();
  rayin.dy = S3E->text().toDouble();
  rayin.dz = S4E->text().toDouble();
  rayin.phi= S5E->text().toDouble();

  rayin.dz*= 1e-3; // into rad
  rayin.dy*= 1e-3; // into rad
  //  bl->beamlineOK |= sourceOK;
  
  myparent->myBuildBeamline();
  //RayTraceSingleRayCpp();
  //BuildBeamline(this->myparent);
  RayTraceSingleRayCpp(this->myparent);

  // the output
  S6Label->setText(qst.setNum(rayout.y, 'g', 4));
  S7Label->setText(qst.setNum(rayout.z, 'g', 4));
  S8Label->setText(qst.setNum(rayout.dy* 1e3, 'g', 4));
  S9Label->setText(qst.setNum(rayout.dz* 1e3, 'g', 4));

  if ((rayout.phi > 360) || (rayout.phi < 1e-3)) 
    qst= tr("undef"); 
  else
    qst.setNum(rayout.phi, 'g', 3);

  S10Label->setText(qst);
  //  this->parent->UpdateStatus();
} // end applySlot

// set defaults for single ray
void SingleRay::defaultSlot()
{
  S1E->setText(QString("0.0"));
  S2E->setText(QString("0.0"));
  S3E->setText(QString("0.0"));
  S4E->setText(QString("0.0"));
  S5E->setText(QString("0.0"));
} // end defaultSlot

void SingleRay::quitSlot()
{
  cout << "quitSlot called" << endl;
  singleRayBox->close();
} // quitSlot

// reimplemented from rtrace.c
// we do not use the source and result pointer
// i.e. single ray trace is possible in addition to other calculations
void SingleRay::RayTraceSingleRayCpp(PhaseQt *bl)
{
  struct RayType *Raysin, *Raysout, Tmpsource, Tmpresult;   
  int          elnumber;
  unsigned int elcounter;
  double       uu, ww, ll, xlength, xlength1, xlength2, phase, raylen, 
    slopelen= -1.0, dela, res, dphase;
  struct ElementType *ds; 
  
  Raysin = &rayin;   // for compatibility with the previous code we use pointers
  Raysout= &rayout;

#ifdef DEBUG
  printf("debug: RayTraceSingleRayCpp called: beamlineOK: %X\n", bl->beamlineOK);
#endif

  if ((bl->beamlineOK & mapOK) == 0)
    { 
      fprintf(stderr, "RayTraceSingleRayCpp: beamline is not OK: beamlineOK: %X\nreturn\n", 
	      bl->beamlineOK);       
      return;
    }
  
  memcpy(&Tmpsource, &rayin, sizeof(struct RayType));
  /* Schleife ueber die elemente */
  elcounter= 0;
  printf("\n**************** Single Ray *****************\n");
  if (bl->BLOptions.SourcetoImage != 1) 
    printf("RayTraceSingleRay:   Image to source calculation.\n");
  else 
    printf("RayTraceSingleRay:   Source to image calculation.\n");
  
  printf("RayTraceSingleRay:   Beamline contains %d element(s).\n", 
	 bl->elementzahl);
  
  raylen= phase= 0.0;
  while (elcounter< bl->elementzahl)
    {
      elnumber= (bl->BLOptions.SourcetoImage == 1) ?
	elcounter+ 1 : bl->elementzahl- elcounter; 
      printf("\n==>element number %d ==> results:\n", elnumber);
      ds= &(bl->ElementList[elnumber- 1]);

/* ab hier wird ein voller rt durchgefuehrt */
      Raysin= &Tmpsource; Raysout= &Tmpresult;
      if (ds->MDat.Art == kEOESlit) /* Sonderbehandlung Spalt */
	{
	  uu = 0.0; ww= Raysin->y; ll= Raysin->z;
	}
      else
	{

          intersection(&ds->mir, ds->wc, ds->xlc, Raysin, 
		       &uu, &ww, &ll, &bl->BLOptions.ifl.iord); 

	}
      printf("  intersection: u= %.4g (mum), w= %.4g (mm), l= %.4g (mm)\n", 
	     uu* 1e3 , ww, ll);

      if (OnElement(&ds->MDat, ww, ll) == 0)
	{
	  beep(1);
	  printf("!!! ray got lost on element number %d ==> exit\n", 
	  	 elnumber);
	  QMessageBox::information(this, tr("Phase: RayTraceSingleRayCpp"),
				   tr("ray got lost on element number %1.\n set output to input!").arg(elnumber));
	            
	  /* setze out wie in */
	  memcpy(&rayout, &Tmpsource, sizeof(struct RayType)); 
	  elcounter= bl->elementzahl+ 1; /* Abbruch */
	}
      else   // not lost
	{
	  if (ds->MDat.Art == kEOESlit) /* Sonderbehandlung Spalt */
	    {
	      memcpy(Raysout, Raysin, sizeof(struct RayType));
	      xlength1= xlength2= xlength= 0.0;
	    }
	  else // not lost and not slit 
	    {
	      
	      ray_tracef(Raysin, Raysout, &bl->BLOptions.ifl.iord, 
			 (double *)ds->ypc1, (double *)ds->zpc1, 
			 (double *)ds->dypc, (double *)ds->dzpc);
	      pathlen1(&ds->xlm, Raysin, &bl->BLOptions.ifl.iord, 
		       &xlength1, &xlength2, &xlength); 
	      
	      /* if ((bl->BLOptions.CalcMod & SlopeMod) == SlopeMod) */
	      slopelen= (bl->BLOptions.SourcetoImage == 1) ? 
		ds->GDat.rp : ds->GDat.r; 
	      
	      if (bl->BLOptions.WithAlign == 1)
		{
		  printf("include Slope error: ew= %lf, el= %lf\n", ds->MDat.slopew, ds->MDat.slopel);
		  Slope(Raysout, ds->MDat.slopew, ds->MDat.slopel, 
			slopelen, ds->geo.cosb, ds->GDat.azimut); 
		}
	    }
	  /* calculate phase */
	  dphase= (bl->BLOptions.lambda > 0) ? 
	    ((xlength/ bl->BLOptions.lambda)* 2.0* PI) : (2.0* PI);
	  
	  raylen+= xlength;
	  phase += dphase;
          
	  /* 2PI entspricht lambda= 0 */
	  /* Ausgabe */
	  
	  printf("  ray trace: \n"); 
	  printf("    yi : % .4g,\tyo : % .4g\t (mm)\n", 
		 Raysin->y, Raysout->y);  
	  printf("    zi : % .4g,\tzo : % .4g\t (mm)\n", 
		 Raysin->z, Raysout->z);  
	  printf("    dyi: % .4g,\tdyo: % .4g\t (mrad)\n", 
		 Raysin->dy  * 1e3, Raysout->dy * 1e3);    
	  printf("    dzi: % .4g,\tdzo: % .4g\t (mrad)\n", 
		 Raysin->dz * 1e3, Raysout->dz  * 1e3); 
	  
	  printf("  pathlength over element: %.4g, \ttotal: %.4g \t(nm)\n", 
		 xlength* 1e6, raylen* 1e6);
	  printf("  time delay over element: %.4g, \ttotal: %.4g \t(fs)\n", 
		 xlength* 1e15/LIGHT_VELO, raylen* 1e15/LIGHT_VELO);
	  printf("  phaseshift over element: %.4g, \ttotal: %.4g \t(rad)\n",
		 dphase, phase);
#ifdef DEBUG
	  printf("      debug: xlength1: %g mm, xlength2: %g mm\n", 
		 xlength1, xlength2);    
	  printf("             slopelength: %g mm, wavelength: %g nm\n", 
		 slopelen, bl->BLOptions.lambda);       
#endif		
	  memcpy(&Tmpsource, &Tmpresult, sizeof(struct RayType));
	  memcpy(&rayout,    &Tmpresult, sizeof(struct RayType)); 
	  elcounter++;
	} // end else
    } // end elements

  printf("  energy resolution: \t");
  dela= Raysout->y * bl->deltalambdafactor* 1e6;
  if (fabs(dela) < 1e-18)
    {
      printf("infinity\n");
      printf("     DeltaLambda= 0.0 nm ==> Lambda= %g (nm)\n", 
	     bl->BLOptions.lambda * 1e6);
    } 
  else
    {
      res= fabs(bl->BLOptions.lambda/ dela);
      printf("%.4g\n", res);
      printf("     DeltaLambda= %g nm ==> Lambda= %g nm\n", 
	     dela, bl->BLOptions.lambda+ dela);
    }
  printf("********** end RayTraceSingleRay *******************\n\n"); 
  
} /* RayTraceSingleRayCpp*/


// end

