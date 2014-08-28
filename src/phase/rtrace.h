/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/phase/rtrace.h */
/*  Date      : <28 Nov 06 09:06:56 flechsig>  */
/*  Time-stamp: <28 Aug 14 16:47:10 flechsig>  */
/*  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */


/* Datei: USERDISK_3:[FLECHSIG.PHASE.PHASEC]RTRACE.H           */
/* Datum: 28.MAR.1995                                          */
/* Stand: 29-APR-1996                                          */
/* Autor: FLECHSIG, BESSY Berlin                               */

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



#ifndef __RTRACE_LOADED
#define __RTRACE_LOADED	1         

int MakeRTSource(struct PHASEset *, struct BeamlineType *);

void RayTracec(struct BeamlineType *), 
        
     WritePlotFile(char *, int *, struct RayType *),     
     WriteRayFile (char *, int *, struct RayType *), 
     MakeHardEdgeSource (struct RTSourceType *), 
     MakeUndulatorSource(struct RTSourceType *, char),  
     MakeDipolSource    (struct RTSourceType *),
     AllocRTSource(struct BeamlineType *),
     ReAllocResult(struct BeamlineType *, int, int, int),
     FreeResultMem(struct RESULTType *);
             
#ifdef LINUX
  #define ray_tracef ray_tracef_
#endif

extern void extractmap35(double *, double*, double *, double *, double*, 
			 int *),
	    ray_tracef(struct RayType *, struct RayType *, int *, 
                       double *, double*, double *, double *),
            readmatrixfile35(FString *, double *);
	    
double gauss(double);
#endif
/* end rtrace.h */
