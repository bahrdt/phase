 /* File      : /afs/psi.ch/project/phase/src/phase/heighterror.c */
 /* Date      : <05 May 14 14:12:11 flechsig>  */
 /* Time-stamp: <2014-05-19 23:31:46 flechsig>  */
 /* Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

 /* $Source$  */
 /* $Date$ */
 /* $Revision$  */
 /* $Author$  */


#ifdef HAVE_CONFIG_H
  #include "config.h"
#endif 

#include "hdf5.h"
#include "myhdf5.h"

#include <stdio.h>
#include <string.h>
#include <math.h>

#include "cutils.h"
#include "phase_struct.h"
#include "phase.h"
#include "posrc.h"
#include "rtrace.h"
#include "common.h"
#include "heighterror.h"

// called from fortran (adaptive_int)
// function: aperture check and height error phase shift
// uf rewrite to amplitude and phase for debugging and consistency (compl. math)
void apply_height_error_(int *blp, double *wwert, double *lwert, 
			 double *eyre, double *eyim, double *ezre, double *ezim)
{
  double u_interp, phaseshift;
  double yamp, ypha, zamp, zpha;
  struct BeamlineType *bl;
  struct ElementType  *el;
  struct SurfaceType  *sf;
    
  //lvars for local copies
  double lambda, cosa, cosb;
  
#ifdef DEBUG1
  printf("\ndebug: apply_height_error_ called! file: %s\n", __FILE__);
#endif
  
   bl= (struct BeamlineType *)blp;
   el= &bl->ElementList[0];
   sf= &el->surf;
   
   // check w, l, set field outside to zero
   // increase the number of lost principle rays
   if ((*wwert < el->MDat.w1) || (*wwert > el->MDat.w2) || 
       (*lwert < el->MDat.l1) || (*lwert > el->MDat.l2)) 
     {
       ((struct PSDType *)bl->RESULT.RESp)->outside_wl++;
       *eyre= *eyim= *ezre= *ezim= 0.0;
       return;
     }

   // return if height error is switched off
   if (! bl->BLOptions.PSO.with_herror)
    {
#ifdef DEBUG1
      printf("debug: %s slope errors calculation switched off - return\n", __FILE__);
#endif
      return;
    }
  
   // calc ampl and phase from re and im
   yamp= sqrt(pow(*eyre, 2.0) + pow(*eyim, 2.0));
   zamp= sqrt(pow(*ezre, 2.0) + pow(*ezim, 2.0));
   ypha= atan2(*eyim, *eyre);
   zpha= atan2(*ezim, *ezre);

   lambda = bl->BLOptions.lambda; // in [mm]
   cosa   = el->geo.cosa;
   cosb   = el->geo.cosb;
  
#ifdef DEBUG1
  printf("debug: apply_height_error_ received values of wwert, lwert: %g, %g\n", 
	 *wwert, *lwert);
#endif

  // get interpolated height for w and l 
  surf_height_interp(sf, wwert, lwert, &u_interp);

  // apply the phase shift=  -k * u * (sin(alpha_g) + sin(beta_g)) ???  
  phaseshift= -2* PI/ lambda* u_interp* (1/fabs(cosa)+ 1/fabs(cosb));

  // apply phase shift
  ypha+= phaseshift;
  zpha+= phaseshift;

  // back to re and im
  *eyre= yamp* cos(ypha);
  *ezre= zamp* cos(zpha);
  *eyim= yamp* sin(ypha);
  *ezim= zamp* sin(zpha);

} // end apply_height_error_


void surf_height_interp(struct SurfaceType *sf, double *wwert, double *lwert, double *u_interp)
{
  double *wvecp, *lvecp, *uvecp;
  int    nw, nl, nu;  
  int    i, j;
  int    index_w, index_l;
  double factor1, factor2, factor3, factor4; 
  double w1, w2, l1, l2, u1, u2, u3, u4, dwl;
    
#ifdef DEBUG1
  printf("debug: surf_height_interp received values of wwert, lwert: %g, %g\n", *wwert, *lwert);
#endif

  // copy the variables locally
  wvecp = sf->w;
  nw    = sf->nw; 
  lvecp = sf->l;
  nl    = sf->nl; 
  uvecp = sf->u;
  nu    = nl* nw;

#ifdef DEBUG1  
  printf("debug: surf_height_interp called! file: %s\n", __FILE__);
#endif 
  
  // start interpolation
  
  // search closest values to wwert and lwert in the vectors for w, l and u
  index_w= 0;
  index_l= 0;
  // add some test to avoid memory overrun
  while (wvecp[index_w] < *wwert) 
    {
      index_w++;
    }
  while (lvecp[index_l] < *lwert) 
    {
      index_l++;
    }
    
  w1 = wvecp[index_w- 1];
  w2 = wvecp[index_w];
  
  l1 = lvecp[index_l- 1];
  l2 = lvecp[index_l];
  
  u1 = uvecp[(index_l- 1)* nw + (index_w- 1)];	// u1 = u(w1,l1)
  u2 = uvecp[(index_l- 1)* nw + index_w];	// u2 = u(w2,l1)
  u3 = uvecp[index_l* nw + (index_w- 1)];	// u3 = u(w1,l2)
  u4 = uvecp[index_l* nw + index_w];		// u4 = u(w2,l2)
  
  //calculation of weight factors
  dwl = (w2- w1)* (l2- l1);
  
  factor1 = (*wwert- w1)* (*lwert- l1) / dwl;
  factor2 = (w2- *wwert)* (*lwert- l1) / dwl;
  factor3 = (*wwert- w1)* (l2- *lwert) / dwl;
  factor4 = (w2- *wwert)* (l2- *lwert) / dwl;
  
  // weighted sum 
  *u_interp = factor1* u4 + factor2* u3 + factor3* u2 + factor4* u1;

    // end of the interpolation
  
#ifdef DEBUG1
  printf("i, j, p  = %d, %d, %d\n", index_w-1, index_l-1, (index_l-1)*nw + (index_w -1));
  printf("w1 , l1, u1 = %g, %g, %.4g\n", w1 , l1, u1);
  printf("w2 , l1, u2 = %g, %g, %.4g\n", w2 , l1, u2);
  printf("w1 , l2, u3 = %g, %g, %.4g\n", w1 , l2, u3);
  printf("w2 , l2, u4 = %g, %g, %.4g\n", w2 , l2, u4);
  printf("fact1 = %g\n", factor1);
  printf("fact2 = %g\n", factor2);
  printf("fact3 = %g\n", factor3);
  printf("fact4 = %g\n", factor4);
  printf("u_interp = %.4g\n", *u_interp);
#endif
  
#ifdef DEBUG1
  printf("debug: %s, surf_height_interp end\n", __FILE__);
#endif
} /* surf_height_interp */

// read file data into element struct
void read_hdf5_height_file(char *fname, struct ElementType *elmp)
{
  hid_t  file_id;           /* group_id       */
  int    nw, nl, nu, i, j;  /* slicecount= 1, */
  struct SurfaceType *sf;
  char   buffer[255];

#ifdef DEBUG  
  printf("debug: read_hdf5_height_file called! file: %s\n", __FILE__);
#endif 

  sf = &elmp->surf;
  
  // clean up
  if (sf->u) XFREE(sf->u);
  if (sf->w) XFREE(sf->w);
  if (sf->l) XFREE(sf->l);
  sf->nw= sf->nl= 0;
  
  if ( !fexists(fname) )
    { 
       fprintf(stderr, "warning: surface error file >>%s<< not found - return\n", fname);
       return;
    }

 /* Open an existing file. */
  file_id = myH5Fopen(fname);

  snprintf(buffer, 254, "/%s/wvec", elmp->elementname);
  nw = getDatasetSize(file_id, buffer);
  snprintf(buffer, 254, "/%s/lvec", elmp->elementname);
  nl = getDatasetSize(file_id, buffer);
  nu = nw*nl;
  
//   double buffer_w[nw];
//   double buffer_l[nl];
//   double buffer_u[nu];
  
  if (nu != nw*nl)
  {
    printf("stderr: read_hdf5_height_file: error on the vector sizes of the surface profile %s\n", __FILE__);
    printf("stderr: read_hdf5_height_file: surface file %s\n", fname);
  }
    

#ifdef DEBUG1  
  printf("debug: read_hdf5_height_file: number of points wvec= %d, lvec= %d\n", nw, nl);;
  printf("debug: read_hdf5_height_file: number of height points %d\n", nu);
#endif 
  

  sf->w = XMALLOC(double, nw); // allocate memory
  sf->l = XMALLOC(double, nl);
  sf->u = XMALLOC(double, nu);

  // load the values to the beamline->element->surface object WG
  snprintf(buffer, 254, "/%s/height_vec", elmp->elementname);
  readDataDouble(file_id, buffer, sf->u, nu); 
  snprintf(buffer, 254, "/%s/wvec", elmp->elementname);
  readDataDouble(file_id, buffer,       sf->w, nw);
  snprintf(buffer, 254, "/%s/lvec", elmp->elementname);
  readDataDouble(file_id, buffer,       sf->l, nl);
  
  sf->nw= nw;
  sf->nl= nl;
  
  for (i= 0; i < nw; i++) sf->w[i] = sf->w[i]* 1e3;
  for (i= 0; i < nl; i++) sf->l[i] = sf->l[i]* 1e3;
  for (i= 0; i < nu; i++) sf->u[i] = sf->u[i]* 1e3;
  
  
//   *sf->u=buffer_u; //convertion from m (hdf5) to mm (phase standard)
//   *sf->w=buffer_w;
//   *sf->l=buffer_l;

  
  H5Fclose(file_id);
  
  printf("read_hdf5_height_file: %s => done\n", fname);
  

// #ifdef DEBUG1  
//   for (i= 0; i < nw - 1; i = i + 1)
//   {
//       for (j= 0; j < nl - 1; j= j + 1)
// 	{
// 	  printf("(i, j, p) = %d, %d, %d\n", i, j, j*nw+i);
// 	  printf("(w, l, u) = %g, %g, %g\n", sf->w[i], sf->l[j], sf->u[j*nw+i]);
// 	}
//   }
// #endif 
  
}  /* read_hdf5_file */

// end /afs/psi.ch/project/phase/src/phase/heighterror.c
