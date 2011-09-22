/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseqt/phaseqt.h */
/*  Date      : <31 May 11 17:01:23 flechsig>  */
/*  Time-stamp: <16 Sep 11 17:50:06 flechsig>  */
/*  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */

#ifndef PHASEQT_H
#define PHASEQT_H

#ifdef HAVE_CONFIG_H
  #include <config.h>
#endif

#include <stdio.h>
#include <string>
#include <iostream>

#include "plot.h"   // UF not sure

extern "C" {
  #include "cutils.h"
  #include "rtrace.h"
  #include "phase_struct.h"
  #include "phase.h"
  #include "common.h"
}

class MainWindow; // forward declaration

// nach phase.h
//#include "singleray.h"

# define NPARS 64


// our class inherits the structures from c like base classes
// !! they are considered public !!
// we should define member functions to access/modify them
class PhaseQt : public PHASEset, public BeamlineType 
{
  //  char my_global_rundir[MaxPathLength];
public:
  PhaseQt();
  // add here member functions to access the structs PHASEset and BeamlineType
  void initSet(const char *);
  void printSet();
  void initBeamline();
  struct BeamlineType *myBeamline();
  struct OptionsType *myOptions();
  struct PHASEset *myPHASEset(); 
  void myAllocRTSource() { AllocRTSource(this); }
  void myBatchMode(int cmode, int selected) { BatchMode(this, this, cmode, selected); }
  void myBuildBeamline() { BuildBeamline(this); }
  void myDefGeometryC (struct gdatset *x, struct geometrytype *gout) { DefGeometryC(x, gout); }
  void myDefMirrorC (struct mdatset *x, struct mirrortype *a, 
		int etype, double theta, int lREDUCE_maps) { DefMirrorC(x, a, 
		etype, theta, lREDUCE_maps); }
  void myFootprint(unsigned int enummer) { Footprint(this, enummer); }

  void myGetPHASE(char *name) { GetPHASE(this, name); }
  void myMakeMapandMatrix(struct ElementType *listpt) { MakeMapandMatrix(listpt, this); }
  void myMakeRTSource() { MakeRTSource(this, this);  }
  
  int  myProcComandLine(int argc, char *argv[], int *cmode, int *selected) { return ProcComandLine(this, argc, argv, cmode, selected); }
  void myPutPHASE(char *name) { PutPHASE(this, name); }
  void myReadBLFile(char *name) { ReadBLFile(name, this); }
  void myReAllocResult(int newtype, int dim1, int dim2)   { ReAllocResult(this, newtype, dim1, dim2); }
  void myRayTracec() { RayTracec(this); }
  void myRayTraceFull() { RayTraceFull(this); }
  void myReadBLFile(char *name){ ReadBLFile(name); }
  void myreadfg34_par(struct sources *src, struct apertures  *apr, struct control_flags *ifl, struct integration *xi, double *epsilon) { readfg34_par(src,apr,ifl,xi,epsilon); }

  void myWriteBLFile(char *name) { WriteBLFile(name, this); }
  void mywritemapc(char *fname, char *header, int iord, 
               double *ypc1, double *zpc1, double *dypc,   double *dzpc,
	       double *wc,   double *xlc,  double *xlen1c, double *xlen2c) { writemapc(fname, header, iord, 
               ypc1, zpc1, dypc,   dzpc,
	       wc,   xlc,  xlen1c, xlen2c); }

  void myWriteRayFile() { WriteRayFile(); }
  void sourceSetDefaults();
  void writeBackupFile();

  // void UpdateElementList();
  //  QtPhase *qtpp;
  struct datset  Fg3ActDat, Fg3DefDat;  
  struct gdatset GActDat,   GDefDat;  
  struct mdatset MActDat,   MDefDat; 

  int ActualTask; 

  
  //private:
  MainWindow *mainWin;   // must be public
  
 private:
  

};



#endif

#ifdef trash
//struct BeamlineType Beamline;  
  #ifdef HEINZ
  // struct BeamlineType Beamline;
  
  int ActualTask;         		/* haelt aktuelle Aufgabe fest */    
  //  QtPhase *qtppp;
  //  const char *global_rundir;

  
  struct datset  Fg3ActDat, Fg3DefDat;  
  struct gdatset GActDat,   GDefDat;  
  struct mdatset MActDat,   MDefDat; 
#endif

#endif
