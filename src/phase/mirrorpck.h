/*   File      : /afs/psi.ch/user/f/flechsig/phase/src/phase/mirrorpck.h */
/*   Date      : <16 Feb 04 14:51:56 flechsig>  */
/*   Time-stamp: <09 Jul 04 15:22:36 flechsig>  */
/*   Author    : Uwe Flechsig, flechsig@psi.ch */

/*   $Source$  */
/*   $Date$ */
/*   $Revision$  */
/*   $Author$  */


#ifndef __MIRRORPCK_LOADED
#define __MIRRORPCK_LOADED	1 

#define 	MirrorPickFileHeader	"MirrorPickFileType"    

#define 	D0r1            10000    /* defaults in mm, degree */
#define 	D0r2            1000
#define 	D0alpha         80
#define 	D0rmi           2000
#define 	D0rho           2000   
#define 	D0iflagmi       0 
#define         D0ww            100
#define         D0l             10
#define         D0slopew        0.1
#define         D0slopel        1.0
#define         D0Art           188        /* kEOEDefaults */

struct grating
{
    double alpha, beta, lambda, n[5], r, rho;
    int    order;
};

struct mdatset 
{
  double r1;
  double r2;
  double alpha;        
  double rmi;        
  double rho;  
  int    iflagmi;
  double w1, w2, l1, l2;
  double slopew, slopel;
  double du, dw, dl, dRu, dRw, dRl;
  int Art;   /* UF 9.7.04 */
};   

int  	mgetpickfile(struct mdatset *, char *); 
   
void 	mputpickfile(struct mdatset *, char *),
	minitdatset (struct mdatset *);    
                                      
#endif 

