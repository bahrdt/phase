/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/phase/posrc.h */
/*  Date      : <23 Apr 12 10:44:55 flechsig>  */
/*  Time-stamp: <08 Jan 15 13:59:17 flechsig>  */
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


/* soure routines for physical optics */
/* replaces routines in phase_source.F, only source4 is implemented so far, the reason is the extension to unlimited gridsize */

#ifndef POSRC_H
#define POSRC_H

#define PHASE_H5_VERSION 20140512

#ifdef HAVE_HDF5
   #include "hdf5.h"
#endif 

void check_file_consistency(struct BeamlineType *, int, int);
void emf_construct(struct EmfType *, int, int);
struct EmfType *emfp_construct(int, int);
void emf_free(struct EmfType *);
void emfp_cpy(struct EmfType *, struct EmfType *);
void emfp_fill4(struct BeamlineType *, double *, FILE *, int);
void emfp_fill7(struct BeamlineType *, double *, double *, int, int, int);
void emfp_fill8(struct BeamlineType *, double *, double *, int, double);
struct EmfType *emfp_free(struct EmfType *);
//void emfp_2_psd(struct BeamlineType *);
//void emfp_2_source4c(struct BeamlineType *);
void gauss_source1c(struct BeamlineType *);
void posrc_construct(struct BeamlineType *);
FILE *posrc_fopen(char *);
int  posrc_ini(struct BeamlineType *);

int  source4c_ini(struct BeamlineType *);
void source7c_ini(struct BeamlineType *, int);
void source8c_ini(struct BeamlineType *);
void source4c_inter_2d_(struct source_results *, double *, double *, int *);

#ifdef HAVE_HDF5
int   check_hdf5_type(char *, int, int);
struct EmfType *read_hdf5_file(struct BeamlineType *, char *, struct EmfType *);
void  write_genesis_hdf5_file(struct BeamlineType *, char *, struct EmfType *);
void  write_phase_hdf5_file(struct BeamlineType *, char *, struct EmfType *);
#endif

#endif 
/* end POSRC_H */
