 // File      : /import/home/flechsig/phase/src/opti_root/cost.cpp
 // Date      : <2012-11-04 12:01:05 flechsig> 
 // Time-stamp: <13 May 13 14:39:55 flechsig> 
 // Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

 // $Source$ 
 // $Date$
 // $Revision$ 
 // $Author$ 

// example of a custom cost function
// the function expects the beamline pointer and should return a double value > 0.0

#ifdef HAVE_CONFIG_H
  #include "config.h"
#endif


#include <math.h>
#include <stdio.h>


#include "../phase/cutils.h"
#include "../phase/common.h"
#include "../phase/phase_struct.h"
#include "../phase/phase.h"
#include "../phase/rtrace.h"
#include "../opti/optisubc.h"
#include "cost.h"


double cost(struct BeamlineType *bl)
{
  double val, dz, dy;

#ifdef DEBUG
  //  cout << "call user cost function " << __FILE__ << endl;
#endif
  
  Get_dydz_fromSource(bl, &dy, &dz); // in case we like to get the divergency from the source
  
  val= fabs(bl->ypc1[0][0][1][0] * dy +                // defocusing
	    bl->ypc1[0][0][0][2] * pow(dz, 2) +
	    bl->ypc1[0][0][2][0] * pow(dy, 2) +        // coma
	    bl->ypc1[0][0][1][2] * dy * pow(dz, 2) +
	    bl->ypc1[0][0][3][0] * pow(dy, 3)         // sph abb.
	    );
  
#ifdef DEBUG
  printf("call user cost function %s return value= %lg\n", __FILE__, val);
#endif

  return val;
}
// end /import/home/flechsig/phase/src/opti_root/cost.cpp
