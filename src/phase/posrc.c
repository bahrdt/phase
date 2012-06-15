/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/phase/posrc.c */
/*  Date      : <23 Apr 12 10:44:55 flechsig>  */
/*  Time-stamp: <15 Jun 12 09:36:54 flechsig>  */
/*  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */

/* soure routines for physical optics */
/* replaces routines in phase_source.F, only source4 is implemented so far, the reason is the extension to unlimited gridsize */
/* the data is stored in bl->posrc */

#ifdef HAVE_CONFIG_H
  #include <config.h>
#endif 

#include <stdio.h>
#include <math.h>
#include "cutils.h"
#include "phase_struct.h"
#include "phase.h"
#include "posrc.h"
#include "common.h" 

/* reads the source files and puts the results into bl->posrc */
void source4c_ini(struct BeamlineType *bl)
{
  FILE *fa, *fb, *fc, *fd;
  struct source4c *so4;
  int i, j;
  
#ifdef DEBUG
  printf("debug: %s source4c_ini called\n", __FILE__);
#endif
  
  /* open files, return if a file is not found */ 
  if ((fa= fopen(bl->filenames.so4_fsource4a, "r")) == NULL)
    {
      printf("error: file: %s not found- return\n", bl->filenames.so4_fsource4a);
      return;
    }
  
  if ((fb= fopen(bl->filenames.so4_fsource4b, "r")) == NULL)
    {
      printf("error: file: %s not found- return\n", bl->filenames.so4_fsource4b);
      return;
    }
  
  if ((fc= fopen(bl->filenames.so4_fsource4c, "r")) == NULL)
    {
      printf("error: file: %s not found- return\n", bl->filenames.so4_fsource4c);
      return;
    }
  
  if ((fd= fopen(bl->filenames.so4_fsource4d, "r")) == NULL)
    {
      printf("error: file: %s not found- return\n", bl->filenames.so4_fsource4d);
      return;
    }
  /* all files open */
  
  if (bl->posrc.zeyre != NULL) XFREE(bl->posrc.zeyre);                   /* free memory */
  if (bl->posrc.zeyim != NULL) XFREE(bl->posrc.zeyim);   
  if (bl->posrc.zezre != NULL) XFREE(bl->posrc.zezre);
  if (bl->posrc.zezim != NULL) XFREE(bl->posrc.zezim);
  if (bl->posrc.gridx != NULL) XFREE(bl->posrc.gridx);
  if (bl->posrc.gridy != NULL) XFREE(bl->posrc.gridy);
  
  /* y real */
  printf("read file: %s ", bl->filenames.so4_fsource4a);
  fscanf(fa, "%d %d", &bl->posrc.ieyrex, &bl->posrc.ieyrey);             /* read first line */
  bl->posrc.zeyre= XMALLOC(double, bl->posrc.ieyrex * bl->posrc.ieyrey); /* allocate */
  bl->posrc.gridx= XMALLOC(double, bl->posrc.ieyrex);
  bl->posrc.gridy= XMALLOC(double, bl->posrc.ieyrey);
  
  for (j=0; j< bl->posrc.ieyrey; j++)                 /* fill matrix in fortran memory model */
    for (i=0; i< bl->posrc.ieyrex; i++) 
      fscanf(fa, "%lf %lf %lf", &bl->posrc.gridx[i], &bl->posrc.gridy[j], &bl->posrc.zeyre[i+ j* bl->posrc.ieyrex]);

  bl->posrc.xeyremin= bl->posrc.gridx[0]; 
  bl->posrc.yeyremin= bl->posrc.gridy[0];
  bl->posrc.xeyremax= bl->posrc.gridx[bl->posrc.ieyrex- 1];
  bl->posrc.yeyremax= bl->posrc.gridy[bl->posrc.ieyrey- 1];
  bl->posrc.dxeyre  = (bl->posrc.xeyremax- bl->posrc.xeyremin)/(double)(bl->posrc.ieyrex- 1);
  bl->posrc.dyeyre  = (bl->posrc.yeyremax- bl->posrc.yeyremin)/(double)(bl->posrc.ieyrey- 1);
  fclose(fa);
  printf(" ==> done\n");
  
  /* y imag */
  printf("read file: %s ", bl->filenames.so4_fsource4b);
  fscanf(fb, "%d %d", &bl->posrc.ieyimx, &bl->posrc.ieyimy);             /* read first line */
  if ((bl->posrc.ieyimx != bl->posrc.ieyrex) || (bl->posrc.ieyimy != bl->posrc.ieyrey))
    {
      printf("error with file dimensions- exit\n");
      exit;
    }
  bl->posrc.zeyim= XMALLOC(double, bl->posrc.ieyimx * bl->posrc.ieyimy); /* allocate */
  
  for (j=0; j< bl->posrc.ieyimy; j++)                 /* fill matrix in fortran memory model */
    for (i=0; i< bl->posrc.ieyimx; i++) 
      {
	fscanf(fb, "%lf %lf %lf", &bl->posrc.gridx[i], &bl->posrc.gridy[j], &bl->posrc.zeyim[i+ j* bl->posrc.ieyimx]);
	if (bl->posrc.iconj == 1) bl->posrc.zeyim[i+ j* bl->posrc.ieyimx]*= -1.0;
      }
  
  bl->posrc.xeyimmin= bl->posrc.gridx[0];
  bl->posrc.yeyimmin= bl->posrc.gridy[0];
  bl->posrc.xeyimmax= bl->posrc.gridx[bl->posrc.ieyimx- 1];
  bl->posrc.yeyimmax= bl->posrc.gridy[bl->posrc.ieyimy- 1];
  bl->posrc.dxeyim  = (bl->posrc.xeyimmax- bl->posrc.xeyimmin)/(double)(bl->posrc.ieyimx- 1);
  bl->posrc.dyeyim  = (bl->posrc.yeyimmax- bl->posrc.yeyimmin)/(double)(bl->posrc.ieyimy- 1);
  fclose(fb);
  printf(" ==> done\n");
  
  /* z real */
  printf("read file: %s ", bl->filenames.so4_fsource4c);
  fscanf(fc, "%d %d", &bl->posrc.iezrex, &bl->posrc.iezrey);             /* read first line */
  if ((bl->posrc.iezrex != bl->posrc.ieyrex) || (bl->posrc.iezrey != bl->posrc.ieyrey))
    {
      printf("error with file dimensions- exit\n");
      exit;
    }
  bl->posrc.zezre= XMALLOC(double, bl->posrc.iezrex * bl->posrc.iezrey); /* allocate */
  
  for (j=0; j< bl->posrc.iezrey; j++)                 /* fill matrix in fortran memory model */
    for (i=0; i< bl->posrc.iezrex; i++) 
      fscanf(fc, "%lf %lf %lf", &bl->posrc.gridx[i], &bl->posrc.gridy[j], &bl->posrc.zezre[i+ j* bl->posrc.iezrex]);
  
  bl->posrc.xezremin= bl->posrc.gridx[0];
  bl->posrc.yezremin= bl->posrc.gridy[0];
  bl->posrc.xezremax= bl->posrc.gridx[bl->posrc.iezrex- 1];
  bl->posrc.yezremax= bl->posrc.gridy[bl->posrc.iezrey- 1];
  bl->posrc.dxezre  = (bl->posrc.xezremax- bl->posrc.xezremin)/(double)(bl->posrc.iezrex- 1);
  bl->posrc.dyezre  = (bl->posrc.yezremax- bl->posrc.yezremin)/(double)(bl->posrc.iezrey- 1);
  fclose(fc);
  printf(" ==> done\n");
  
  /* z imag */
  printf("read file: %s ", bl->filenames.so4_fsource4d);
  fscanf(fd, "%d %d", &bl->posrc.iezimx, &bl->posrc.iezimy);             /* read first line */
  if ((bl->posrc.iezimx != bl->posrc.ieyrex) || (bl->posrc.iezimy != bl->posrc.ieyrey))
    {
      printf("error with file dimensions- exit\n");
      exit;
    }
  bl->posrc.zezim= XMALLOC(double, bl->posrc.iezimx * bl->posrc.iezimy); /* allocate */
  
  for (j=0; j< bl->posrc.iezimy; j++)                 /* fill matrix in fortran memory model */
    for (i=0; i< bl->posrc.iezimx; i++) 
      {
	fscanf(fd, "%lf %lf %lf", &bl->posrc.gridx[i], &bl->posrc.gridy[j], &bl->posrc.zezim[i+ j* bl->posrc.iezimx]);
	if (bl->posrc.iconj == 1) bl->posrc.zezim[i+ j* bl->posrc.iezimx]*= -1.0;
      }
  
  bl->posrc.xezimmin= bl->posrc.gridx[0];
  bl->posrc.yezimmin= bl->posrc.gridy[0];
  bl->posrc.xezimmax= bl->posrc.gridx[bl->posrc.iezimx- 1];
  bl->posrc.yezimmax= bl->posrc.gridy[bl->posrc.iezimy- 1];
  bl->posrc.dxezim  = (bl->posrc.xezimmax- bl->posrc.xezimmin)/(double)(bl->posrc.iezimx- 1);
  bl->posrc.dyezim  = (bl->posrc.yezimmax- bl->posrc.yezimmin)/(double)(bl->posrc.iezimy- 1);
  fclose(fd);
  printf(" ==> done\n");
  
#ifdef DEBUG
  so4= (struct source4c *)&(bl->posrc);
  printf("debug: limits: %g < %s < %g, %g < %s < %g\n", 
	 so4->xeyremin, "y", so4->xeyremax,  so4->yeyremin, "z", so4->yeyremax);
  printf("debug: source4c_ini done\n");
#endif
}  /* source4c_ini */

/* output interpolated source_results for x and y     */
/* c replacement of source_inter_2d in phase_source.F */
/* takes integer pointer to beamline struct           */
/* range test is included!                            */
/* !! reads the input from bl->posrc and not sources! */
/* routine wird gerufen von fortran - daher underscore  */
void source4c_inter_2d_(struct source_results *sr, double *xwert, double *ywert, int *blp)
{
  struct BeamlineType *bl;
  struct source4c *so4;
  int    ix1, ix2, iy1, iy2;
  double x1, x2, y1, y2, ddxy, fact3, fact4, fact5, fact6;
  
#ifdef DEBUG1
  printf("debug: %s source4c_inter_2d_ called\n\n", __FILE__);
#endif

  bl = (struct BeamlineType *)blp;
  so4= (struct source4c *)&(bl->posrc);

#ifdef DEBUG1
  printf("debug: %s : x= %f, y= %f, position: %d\n", __FILE__, *xwert, *ywert, bl->position);
  printf("debug: %s : limits: %e < %e < %e, %e < %e < %e\n", __FILE__, 
	 so4->xeyremin, *xwert, so4->xeyremax,  so4->yeyremin, *ywert, so4->yeyremax);
#endif

  if ((*xwert < so4->xeyremin) || (*xwert > so4->xeyremax) || 
      (*ywert < so4->yeyremin) || (*ywert > so4->yeyremax)) 
    {
      //      printf("out of range: %f, %f \n", *xwert , *ywert);
      return;
    }
  

//  fact1=cs.sqrtm1; ! UF 6.6.12 wird gar nicht genutzt

//c---------- es wird gleiches Raster fuer Real- und
//c---------- Imaginaerteil sowie fuer Ey und Ez vorausgesetzt
//c---------- Aenderungen 17.3.2006

//c---------  Interpolation of Ey

// im c- code muss die +1 weg bei ix1 und iy1

  ix1= (int)((*xwert- so4->xeyremin)/so4->dxeyre);
  ix2= ix1+ 1;
  iy1= (int)((*ywert- so4->yeyremin)/so4->dyeyre);
  iy2= iy1+ 1;

  x1  = so4->gridx[ix1];
  x2  = so4->gridx[ix2];
  y1  = so4->gridy[iy1];
  y2  = so4->gridy[iy2];
  ddxy= so4->dxeyre* so4->dxeyre;             // muesste das nicht so4->dxeyre* so4->dyeyre sein ??? UF 14.6.12

  fact3= ((x2- *xwert)* (y2- *ywert))/ ddxy;
  fact4= ((*xwert- x1)* (y2- *ywert))/ ddxy;
  fact5= ((x2- *xwert)* (*ywert- y1))/ ddxy;
  fact6= ((*xwert- x1)* (*ywert- y1))/ ddxy;

  sr->densyre= fact3* so4->zeyre[ix1+ iy1* so4->ieyrex]+
    fact4* so4->zeyre[ix2+ iy1* so4->ieyrex]+
    fact5* so4->zeyre[ix1+ iy2* so4->ieyrex]+
    fact6* so4->zeyre[ix2+ iy2* so4->ieyrex];
  
  sr->densyim= fact3* so4->zeyim[ix1+ iy1* so4->ieyrex]+
    fact4* so4->zeyim[ix2+ iy1* so4->ieyrex]+
    fact5* so4->zeyim[ix1+ iy2* so4->ieyrex]+
    fact6* so4->zeyim[ix2+ iy2* so4->ieyrex];
  
  //c---------  Interpolation of Ez, same grid as for Ey

  sr->denszre= fact3* so4->zezre[ix1+ iy1* so4->ieyrex]+
    fact4* so4->zezre[ix2+ iy1* so4->ieyrex]+
    fact5* so4->zezre[ix1+ iy2* so4->ieyrex]+
    fact6* so4->zezre[ix2+ iy2* so4->ieyrex];
  
  sr->denszim= fact3* so4->zezim[ix1+ iy1* so4->ieyrex]+
    fact4* so4->zezim[ix2+ iy1* so4->ieyrex]+
    fact5* so4->zezim[ix1+ iy2* so4->ieyrex]+
    fact6* so4->zezim[ix2+ iy2* so4->ieyrex];

#ifdef DEBUG1
  printf("debug: %s-> source4c_inter_2d_: sr->densyre= %lg\n", __FILE__, sr->densyre);
#endif
} /* end source4c_inter_2d_ */
/* end */
