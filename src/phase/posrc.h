/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/phase/posrc.h */
/*  Date      : <23 Apr 12 10:44:55 flechsig>  */
/*  Time-stamp: <2013-03-12 10:48:16 flechsig>  */
/*  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */

/* soure routines for physical optics */
/* replaces routines in phase_source.F, only source4 is implemented so far, the reason is the extension to unlimited gridsize */

#ifndef POSRC_H
#define POSRC_H

#ifdef HAVE_HDF5
   #include "hdf5.h"
#endif 

void source4c_ini(struct BeamlineType *);
void source7c_ini(struct BeamlineType *);
void source8c_ini(struct BeamlineType *);
void source4c_inter_2d_(struct source_results *, double *, double *, int *);
void reallocate_posrc(struct BeamlineType *, int, int);
void posrc_fill_min_max(struct BeamlineType *);

#ifdef HAVE_HDF5
void readDataDouble(hid_t, char *, double *, int);
void readDataInt(hid_t, char *, int *, int);
int  getDatasetSize(hid_t, char *);
int  hasDataset(hid_t, char *);
hid_t myH5Fopen(char *);
#endif

#endif 
/* end POSRC_H */
