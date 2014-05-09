/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseqt/phaseqt.h */
/*  Date      : <31 May 11 17:01:23 flechsig>  */
/*  Time-stamp: <09 May 14 15:33:53 flechsig>  */
/*  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */

#ifndef PHASEQT_H
#define PHASEQT_H

#ifdef HAVE_CONFIG_H
  #include "config.h"
#endif

#include <stdio.h>
#include <libgen.h>
#include <string>
#include <iostream>
#include <QImage>
#include <QFutureWatcher>
#include <QtCore>

extern "C" {
  #include "cutils.h"
  #include "rtrace.h"
  #include "phase_struct.h"
  #include "phase.h"
  #include "common.h"
  #include "posrc.h"
  #include "myfftw3.h"
  #include "pst.h"
  #include "reflectivity.h"
  #include "heighterror.h"
}

class MainWindow;          // forward declaration

//#define NPARS 65         // 9.5.14
#define NPARS 67
#define PLOT_GO_SOURCE   0x1
#define PLOT_GO_RESULT   0x2
#define PLOT_GO_SPA      0x4
#define PLOT_GO_DIV      0x8
#define PLOT_GO_PHI      0x10
#define PLOT_PO_RESULT   0x20
#define PLOT_PO_SOURCE   0x40

#define PLOT_EXAMPLE1 0x80
#define PLOT_EXAMPLE2 0x100
#define PLOT_EXAMPLE3 0x200

#define PLOT_PO_SIMPRE   0x400
#define PLOT_PO_SIMPIM   0x800
#define PLOT_PO_SINTRE   0x1000
#define PLOT_PO_SINTIM   0x2000

#define PLOT_GO_HPS      0x4000
#define PLOT_GO_VPS      0x8000

#define PLOT_PO_PHASE_Z 0x10000
#define PLOT_PO_PHASE_Y 0x20000

#define PLOT_PO_S0 0x40000
#define PLOT_PO_S1 0x80000
#define PLOT_PO_S2 0x100000
#define PLOT_PO_S3 0x200000

#define PLOT_UNWRAP 0x400000

#define PLOT_ISO        1
#define PLOT_CONTOUR    2
#define PLOT_CONTOURISO 4
#define PLOT_SCATTER    8
#define PLOT_LINE       16 
#define PLOT_HPROF      32
#define PLOT_VPROF      64

#define INIT_ALL        1

typedef QFutureWatcher <int> ElementWatcher;

/*#define RAY_Y   1
#define RAY_Z   2
#define RAY_DY  4
#define RAY_DZ  8
#define RAY_PHI 16*/

// our class inherits the structures from c like base classes
// !! they are considered public !!
// we should define member functions to access/modify them and not access the data directly
class PhaseQt : public BeamlineType 
{
  //  char my_global_rundir[MaxPathLength];
public:
  PhaseQt();   // constructor
  // add here member functions to access the structs PHASEset and BeamlineType
  // wrapper funktions I call my... and define them here
  int myeval(const int &);
  void buildBeamlineParallel();
  void buildElement(struct ElementType *);
  void initSet(const char *, const int);
  void printSet();
  void initBeamline();
  struct BeamlineType *myBeamline();          // function to return the pointer to the data
  struct OptionsType  *myOptions();
  
  void myAllocRTSource() { AllocRTSource(this); }
  void myBatchMode(int cmode, int selected, int iord, int numthreads, int format) { BatchMode(this, cmode, selected, iord, numthreads, format); }
  void myBuildBeamline() { BuildBeamline(this); }
#ifdef HAVE_HDF5
  int mycheck_hdf5_type(char *name, int type, int verb) { return check_hdf5_type(name, type, verb);}
#endif
  void mycopySrc2Psd() { copySrc2Psd(this); }
  void myDefGeometryC (struct gdatset *x, struct geometrytype *gout) { DefGeometryC(x, gout, &(this->BLOptions)); }
  void myDefMirrorC (struct mdatset *x, struct mirrortype *a, 
		     int etype, double theta, int lREDUCE_maps) { 
    DefMirrorC(x, a, etype, theta, lREDUCE_maps, this->BLOptions.WithAlign, -1); }
  void mydrift_fresnel() { drift_fresnel(this); }
  void mydrift_fraunhofer() { drift_fraunhofer(this); }
  void mydrift_fourier() { drift_fourier(this); }
  void myFootprint(unsigned int enummer) { Footprint(this, enummer); }
  void myGetPHASE(char *name) { GetPHASE(&(this->filenames), name); }
  void myMakeMapandMatrix(struct ElementType *listpt, int *elindex) { MakeMapandMatrix(listpt, this, elindex); }
  void myMakeRTSource() { MakeRTSource(&(this->filenames), this);  }
  void myMPST() { MPST(this); }
  int  myProcComandLine(int argc, char *argv[], int *cmode, int *selected, int *iord, int *numthreads, int *format) { 
    return ProcComandLine(&(this->filenames), argc, argv, cmode, selected, iord, numthreads, format); }
  void myPST() { PST(this); }
  void myFindIntRange() { FindIntRange(this); }  
  void myPutPHASE(char *name) { PutPHASE(&(this->filenames), name); }
  int  myReadBLFile(char *name) { return ReadBLFile(name, this); }
  void myReadCoefficientFile() { }
  void myReAllocResult(int newtype, int dim1, int dim2)   { ReAllocResult(this, newtype, dim1, dim2); }
  void myRayTracec() { RayTracec(this); }
  
  void myRayTraceFull() { RayTraceFull(this); }
  void myread_hdf5_height_file(struct ElementType *ep) { read_hdf5_height_file(this->filenames.h5surfacename, ep); }
  void myreadfg34_par(struct sources *src, struct apertures  *apr, struct control_flags *ifl, 
		      struct integration *xi, double *epsilon) { readfg34_par(src,apr,ifl,xi,epsilon); }
  void mySetReflectivity(struct ElementType *ep) { SetReflectivity(ep, this->BLOptions.lambda* 1e-3); }
  void mysrc_ini(struct sources *src) { src_ini(src); }
  void myposrc_ini() { posrc_ini(this); }
  void mysource7c_ini() { source7c_ini(this); }
  void mysource8c_ini() { source8c_ini(this); }
  void myTest4Grating() { Test4Grating(this); }
  void myUpdateFlags(int run) { UpdateFlags(this, run); }
  void myWriteBLFile(char *name) { WriteBLFile(name, this); }
  void mywritemapc(char *fname, char *header, int iord, 
		   double *ypc1, double *zpc1, double *dypc,   double *dzpc,
		   double *wc,   double *xlc,  double *xlen1c, double *xlen2c) { 
                   writemapc(fname, header, iord, 
			     ypc1, zpc1, dypc,   dzpc,
			     wc,   xlc,  xlen1c, xlen2c); }
  void myWritePsd(char *name, struct PSDType *PSDp) { WritePsd(name, PSDp, PSDp->iy, PSDp->iz, this); }
#ifdef HAVE_HDF5
  void my_read_hdf5_file() { read_hdf5_file(this, this->filenames.hdf5_out); }
  void my_write_genesis_hdf5_file() { write_genesis_hdf5_file(this, this->filenames.hdf5_out); }
  void my_write_phase_hdf5_file() { write_phase_hdf5_file(this, this->filenames.hdf5_out); }
#endif
  void myWriteRayFile(char *name, int *zahl, struct RayType *Rp) { WriteRayFile(name, zahl, Rp); }
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

