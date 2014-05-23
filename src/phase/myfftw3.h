 /* File      : /afs/psi.ch/user/f/flechsig/phase/src/phase/myfftw3.h */
 /* Date      : <06 Jan 14 14:10:12 flechsig>  */
 /* Time-stamp: <23 May 14 11:53:29 flechsig>  */
 /* Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

 /* $Source$  */
 /* $Date$ */
 /* $Revision$  */
 /* $Author$  */


#ifndef MYFFTW3_H
#define MYFFTW3_H

#ifdef HAVE_FFTW3
  #include "fftw3.h"
#endif

double check_sampling(struct BeamlineType *, double *, double, int);
void drift_fourier(struct BeamlineType *);
void drift_fresnel(struct BeamlineType *);
void drift_fraunhofer(struct BeamlineType *);

#ifdef HAVE_FFTW3
void drift_fourier_sub(fftw_complex *, fftw_complex *, fftw_plan *, fftw_plan *, 
		       double *, double *, double *, double *, int, int, 
		       double *, double *, double, double, double, double);
void drift_fraunhofer_sub(fftw_complex *, fftw_complex *, fftw_plan *,  
			  double *, double *, double *, double *, int, int, 
			  double *, double *, double *, double *, double, double, double, double);
void drift_fresnel_sub(fftw_complex *, fftw_complex *, fftw_plan *,  
		       double *, double *, double *, double *, int, int, 
		       double *, double *, double *, double *, double, double, double, double);
void fftshift(fftw_complex *, int, int);
void fill_fftw(fftw_complex *, double *, double *, int, int);
void get_fftw(fftw_complex *, double *, double *, int, int, double);

#endif
#endif
/* end file */
