/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/phasesrv/phasesrv.c */
/*  Date      : <14 Sep 12 16:34:45 flechsig>  */
/*  Time-stamp: <03 Jul 13 15:07:44 flechsig>  */
/*  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */

#ifdef HAVE_CONFIG_H
  #include "config.h"
#endif 

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "mpi.h"

#include "cutils.h" 
#include "phase_struct.h"
#include "phase.h"
#include "rtrace.h"
#include "phasempi.h"

int main(int argc, char *argv[])
{
  int setupswitch, cmode, selected, iord, numthreads, format;
  struct BeamlineType Beamline;
  
  MPI_Init(&argc, &argv);


  Beamline.localalloc= DOALLOC;  /* phasesrv should reserve the memory */ 
  
  printf("phasempi start\n");
  
  setupswitch= ProcComandLine(&Beamline.filenames, argc, argv, &cmode, 
			      &selected, &iord, &numthreads, &format);

#ifdef DEBUG 
  strncpy(Beamline.filenames.beamlinename, "test_5000.phase", MaxPathLength- 1);  /* for debugging */
#endif 

  switch (setupswitch)
    {
    case 1:  // ohne -b
    case 3:
    case 5:  // option -b braucht ist optional
    case 7:
    case 13: // ohne -b
    case 15:
      printf("main: Batchmode  called (switch= %d)\n", setupswitch);
      BatchMode(&Beamline, cmode, selected, iord, numthreads, format);
      break;
    default:
      printf("\nusage: phasesrv -h\n\n");
    }

  printf("phasempi done (switch= %d)\n", setupswitch);

  MPI_Finalize();

  exit(0);
}
/* end */
