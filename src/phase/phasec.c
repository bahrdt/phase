/*   File      : /afs/psi.ch/user/f/flechsig/phase/src/phase/phasec.c */
/*   Date      : <24 Jun 02 09:51:36 flechsig>  */
/*   Time-stamp: <09 Apr 13 16:11:40 flechsig>  */
/*   Author    : Uwe Flechsig, flechsig@psi.ch */
 
/*   $Source$  */
/*   $Date$ */
/*   $Revision$  */
/*   $Author$  */ 

#ifdef HAVE_CONFIG_H
  #include <config.h>
#endif

#include <stdio.h>                    /* For printf and so on. */
#include <stdlib.h> 	      	      /* needed for fopen      */  
#include <string.h>                           
#include <math.h>                                                 
#include <ctype.h>
#include <stdarg.h> 
#include <time.h>
#include <unistd.h>

/* workaround */
#ifdef NOGUI
#define QTGUI
#endif

#ifndef QTGUI
#include <Xm/Text.h>                                                  
#include <Xm/FileSB.h>                /*FileBox*/     
#include <Xm/List.h>   
#include <Xm/ToggleB.h>   
#include <Mrm/MrmAppl.h>  
#include <X11/Xlib.h>      
#include <X11/Xutil.h>  
#endif
#include "cutils.h"   
#include "phase_struct.h"
#include "phase.h"
#ifndef QTGUI

#include "phaseX.h"
#endif
#include "rtrace.h"
#include "version.h"

/* Batchmodus */
void BatchMode(struct BeamlineType *bl,  int cmode, int selected, int iord, int threads, int format)
{
  struct PSDType     *PSDp;
  struct PSImageType *psip;
  time_t start, end;
  int    threadinfo= 1;

  start= time(NULL);
  printf("BatchMode: datafilename  : %s\n", bl->filenames.beamlinename);
  printf("BatchMode: resultfilename: %s\n", bl->filenames.imageraysname);
  /*  InitDataSets(&PHASESet, fname);  initialisiert auch Beamline */
  /* habe die Initialisierung hier extra */
#ifdef LOGFILE 
  CheckUser(logfilename, "Phase Batch");            /* user logfile  */
#endif
  bl->ElementList= NULL;                       /* 15.12.99 */
  bl->raysout= NULL;
  bl->RESULT.RESp= NULL;
  bl->RTSource.SourceRays= NULL;
  bl->beamlineOK= 0;
  bl->tp= NULL;
  ReadBLFile(bl->filenames.beamlinename, bl);

  if (iord != -1)  bl->BLOptions.ifl.iord= iord;  /* overwrite iord */

#ifndef QTGUI
  strncpy(bl->filenames.pssourcename, bl->src.so6.fsource6, MaxPathLength);
#endif
  BuildBeamline(bl); 
  if (cmode == -1) cmode= bl->BLOptions.CalcMod;
  
  switch (cmode)
    {
    case 1:
      printf("BatchMode: Ray Tracing\n");
      MakeRTSource(&(bl->filenames), bl); 
      ReAllocResult(bl, PLrttype, bl->RTSource.raynumber, 0);
      RayTracec(bl);
      WriteRayFile(bl->filenames.imageraysname, &bl->RESULT.points1,
		   bl->RESULT.RESp);
      break;
    case 2:
      printf("BatchMode: Full Ray Tracing\n");
      MakeRTSource(&(bl->filenames), bl); 
      ReAllocResult(bl, PLrttype, bl->RTSource.raynumber, 0);
      RayTraceFull(bl);
      WriteRayFile(bl->filenames.imageraysname, &bl->RESULT.points1,
		   bl->RESULT.RESp); 
      break;
    
    case 3: 
      printf("BatchMode: Phase Space Transformation\n");
#ifdef OLD_PO_SOURCE
      src_ini(&bl->src); 
#else
      posrc_construct(bl);
      posrc_ini(bl);
#endif 
      psip = (struct PSImageType *)bl->RTSource.Quellep;
      ReAllocResult(bl, PLphspacetype, psip->iy, psip->iz);
      PST(bl);
      PSDp= (struct PSDType *)bl->RESULT.RESp;
      switch (format)
	{
	case 1:
	  WritePsd(bl->filenames.imageraysname, PSDp, PSDp->iy, PSDp->iz);
	  break;
	case 2:
	  write_phase_hdf5_file(bl, bl->filenames.imageraysname);
	  break;
	case 3:
	  write_genesis_hdf5_file(bl, bl->filenames.imageraysname);
	  break;
	default:
	  printf("error: %d output format not defined- use default\n", format);
	  WritePsd(bl->filenames.imageraysname, PSDp, PSDp->iy, PSDp->iz);
	}
      break;

    case 4:
      printf("BatchMode: Footprint at element %d\n", selected);
      bl->position= selected;
      MakeRTSource(&(bl->filenames), bl);
      ReAllocResult(bl, PLrttype, bl->RTSource.raynumber, 0);
      Footprint(bl, bl->position);
      WriteRayFile(bl->filenames.imageraysname, &bl->RESULT.points1,
		   bl->RESULT.RESp);
      break;

    case 5:
      printf("BatchMode: multiple Phase Space Imaging\n");
#ifdef OLD_PO_SOURCE
      src_ini(&bl->src); 
#else
      posrc_construct(bl);
      posrc_ini(bl);
#endif 
      psip = (struct PSImageType *)bl->RTSource.Quellep;
      ReAllocResult(bl, PLphspacetype, psip->iy, psip->iz);
      MPST(bl);
      PSDp= (struct PSDType *)bl->RESULT.RESp;
      WritePsd(bl->filenames.imageraysname, PSDp, PSDp->iy, PSDp->iz);
      break;

    case 6: 
      printf("BatchMode: Phase Space Transformation in multiple threads (experimental)\n");
      posrc_construct(bl);
      posrc_ini(bl);
      psip = (struct PSImageType *)bl->RTSource.Quellep;
      ReAllocResult(bl, PLphspacetype, psip->iy, psip->iz);
      //bl->BLOptions.PSO.intmod= 2;
      pst_thread(bl, threads);
      threadinfo= threads;
      PSDp= (struct PSDType *)bl->RESULT.RESp;
      switch (format)
	{
	case 1:
	  WritePsd(bl->filenames.imageraysname, PSDp, PSDp->iy, PSDp->iz);
	  break;
	case 2:
	  write_phase_hdf5_file(bl, bl->filenames.imageraysname);
	  break;
	case 3:
	  write_genesis_hdf5_file(bl, bl->filenames.imageraysname);
	  break;
	default:
	  printf("error: %d output format not defined- use default\n", format);
	  WritePsd(bl->filenames.imageraysname, PSDp, PSDp->iy, PSDp->iz);
	}
      break;

    default: 
      printf("BatchMode: unknown CalcMod: %d\n", cmode);
    }
  end= time(NULL);
  beep(5);
  printf("running time with %d threads (s) = %d\n", threadinfo, (end- start));
  printf("BatchMode: program end\n");
} /* end Batchmode */


int ProcComandLine(struct PHASEset *ps, int argc, char *argv[], int *cmode, int *selected, int *iord, int *numthreads, int *format)
/* Uwe new version 10.8.2011 using getopt */
/* used in phaseqt                        */
{
  char *fvalue = NULL;
  char *mvalue = NULL;
  char *ivalue = NULL;
  char *ovalue = NULL;
  char *svalue = NULL;
  int index;
  int c;
  int ret   =  1;

  *cmode    = -1;
  *selected = -1;
  *iord     = -1;
  opterr    =  0;
  *numthreads= 4;
  *format    = 1; 
  
  /* explicitly init ps->imageraysname to start with '\0',
     so we later can tell whether it was set by -o option */
  //TODO: maybe move that to where structure is initalized first time
  ps->imageraysname[0] = '\0';
  
  /* parse options */
  while ((c = getopt(argc, argv, "BbF:f:Hhi:I:M:m:NnO:o:S:s:T:t:V")) != -1)
    switch (c)
      {
      case 'B':
      case 'b':
	ret += 2;
	printf("option -%c\n", c);
	break;
      case 'F':
      case 'f':
	ret += 4;
	printf("option -%c\n", c);
	fvalue = optarg;
	strncpy(ps->beamlinename, fvalue, MaxPathLength- 1);
	printf("ProcComandLine: use input_filename from parameter: >>%s<<\n", fvalue);
	break;
      case 'H':
      case 'h':
	printf("option -%c\n", c);
	printf("usage: phase [options] [input_filename] [output_filename]\n");
	printf("       options: -b, -B:           batch mode (no X11)\n");
	printf("                -f, -Ffilename:   use datafile (*.phase)\n");
	printf("                -h, -H:           show this message\n");
	printf("                -i, -Iord:        calculation order (0..7)\n");
	printf("                -m, -Mcalcmode:   calculation mode \n");
	printf("                                  1: quick ray trace\n");
	printf("                                  2: (full) ray trace\n");
	printf("                                  3: phase space imaging\n");
	printf("                                  4: footprint (requires option s)\n");
	printf("                                  5: multiple phase space imaging\n");
	printf("                                  6: phase space imaging using multiple threads\n");
	printf("                -n, -N:           no startup- info (X11)\n");
	printf("                -oresultfile:     result filename\n");
	printf("                -Oformat:         po output file format\n");
        printf("                                  1: wave format\n");
	printf("                                  2: phase_hdf5\n");
	printf("                                  3: genesis_hdf5\n"); 
	printf("                -s, -Snumber:     selected element number (for footprint)\n");
	printf("                -t, -Tnumber:     number of threads or tasks (default=4)\n");
	printf("                -V:               Version\n");
	exit(0);
	break;
      case 'I':
      case 'i':
	ivalue = optarg;
	sscanf(ivalue, "%d", iord);
	printf("ProcComandLine: iord: %d\n", *iord);
	break;
      case 'M':
      case 'm':
	mvalue = optarg;
	sscanf(mvalue, "%d", cmode);
	printf("ProcComandLine: calculation mode: %d\n", *cmode);
	break;
      case 'N':
      case 'n':
	ret= 0;
	printf("option -n is obsolete\n");
	break;
      case 'O':
	svalue = optarg;
	sscanf(svalue, "%d", format);
	printf("ProcComandLine: po output format: %d\n", *format);
	break;
      case 'o':
	ret += 8;
	printf("option -%c\n", c);
	ovalue = optarg;
	strncpy(ps->imageraysname, ovalue, MaxPathLength);
	printf("ProcComandLine: use output_filename from parameter: >>%s<<\n", ovalue);
	break;
      case 'S':
      case 's':
	svalue = optarg;
	sscanf(svalue, "%d", selected);
	printf("ProcComandLine: selected element: %d\n", *selected);
	break;
      case 'T':
      case 't':
	svalue = optarg;
	sscanf(svalue, "%d", numthreads);
	printf("ProcComandLine: number of threads: %d\n", *numthreads);
	break;
      case 'V':
	printf("option -%c\n", c);
	printf("Version: %s\n", VERSION);
	exit(0);
	break;	
      case '?':
	switch (optopt)
	  {
	  case 'F':
	  case 'f':
	  case 'I':
	  case 'i':
	  case 'M':
	  case 'm':
	  case 'O':
	  case 'o':
	  case 'S':
	  case 's':
	  case 'T':
	  case 't':
	    fprintf (stderr, "Option -%c requires an argument.\n", optopt);
	    break;
	  default:
	    if (isprint (optopt))
	      fprintf (stderr, "Unknown option `-%c'.\n", optopt);
	    else
	      fprintf (stderr,
		       "Unknown option character `\\x%x'.\n", optopt);
	    exit (-1);
	  }
      default:
	abort ();
      }
  
  /*printf ("aflag = %d, bflag = %d, cvalue = %s\n",
    aflag, bflag, cvalue);*/

  /* no option arguments */   
  index = optind;   
  if (index < argc)  /* wir nehmen das erste argument als filename und ueberschreiben damit den parameter -f */
    {
      strncpy(ps->beamlinename, argv[index], MaxPathLength);
      printf("ProcComandLine: use input_filename from argument: >>%s<<\n", argv[index]);
      ret+= 4;
    }
  index++;
  if (index < argc)  /* wir nehmen das zweite argument als output_filename und ueberschreiben damit den parameter -o */
    {
      strncpy(ps->imageraysname, argv[index], MaxPathLength);
      printf("ProcComandLine: use output_filename from argument: >>%s<<\n", argv[index]);
      ret += 8;
    }

  return ret;
} /* end ProcComandLine */

int GetPHASE(struct PHASEset *x, char *mainpickname)
{
  FILE *f;
  int  rcode, version;
   
  rcode= -1;
  if ((f= fopen(mainpickname, "r")) == NULL)
    fprintf(stderr, "File %s not found- defaults used!\n", mainpickname); 
  else 
    {
      if(CheckFileHeader(f, MainPickFileHeader, &version) == 0)   
	{     
	  if (version > 20120320) 
	    {
	      fscanf(f,"%s\n", (char *) &x->beamlinename);
	    } else
	    {
	      fscanf(f,"%s\n", (char *) &x->matrixname);     
	      fscanf(f,"%s\n", (char *) &x->mapname);    
	      fscanf(f,"%s\n", (char *) &x->sourceraysname);       
	      fscanf(f,"%s\n", (char *) &x->imageraysname);    
	      fscanf(f,"%s\n", (char *) &x->intersecname); 
	      fscanf(f,"%s\n", (char *) &x->geometryname);   
	      fscanf(f,"%s\n", (char *) &x->elementname);  
	      fscanf(f,"%s\n", (char *) &x->sourcepckname);  
	      fscanf(f,"%s\n", (char *) &x->geometrypckname);   
	      fscanf(f,"%s\n", (char *) &x->elementpckname);  
	      fscanf(f,"%s\n", (char *) &x->pssourcename);   
	      fscanf(f,"%s\n", (char *) &x->plotpsname);  
	      fscanf(f,"%s\n", (char *) &x->printpclname); 
	      fscanf(f,"%s\n", (char *) &x->optipckname); 
	      if (!feof(f))    /* neu */
		fscanf(f,"%s\n", (char *) &x->beamlinename); 
	      else strncpy(x->beamlinename, "SGM.PHASE", MaxPathLength); 
	      if (version >= 20081119)
		{
		  fscanf(f,"%s\n", (char *) &x->so4_fsource4a);     
		  fscanf(f,"%s\n", (char *) &x->so4_fsource4b);    
		  fscanf(f,"%s\n", (char *) &x->so4_fsource4c);       
		  fscanf(f,"%s\n", (char *) &x->so4_fsource4d);
		  fscanf(f,"%s\n", (char *) &x->so6_fsource6);
		}
	      if (version >= 20110814)
		fscanf(f,"%s\n", (char *) &x->opresname); 
	    }
	  rcode= 1;       /* OK zurueck */
	}
      fclose(f);   
    }	
  return rcode;
}     /* end  GetPHASE */

/* berechnet den index aus den selektierten Positionen */
/* el: selektiertes element, pos: position             */
/* pos und el starten mit 1                            */
int iindex(int el, int pos)             
{
  int iret, k, mtp, p;
  int start_mtype= 21;                          /* position of first mtype */

  iret = el * pos;        			/* test ob 0 */
  mtp  = (pos >= start_mtype) ? (1 << 7) : 0;   /* position fuer mdaten 128 */
  if (mtp > 0) 
    p= (pos == start_mtype) ? 1 : (81 + pos- start_mtype);
  /*   p= (pos == start_mtype) ? 1 : (36 + pos- start_mtype); bis jul 2011 */
  else 
    p= pos;    
                               
  k    = ((el- 1) << 8) | mtp | (p- 1);
  iret = (iret == 0) ? -1 : k;
  printf("iindex: return: %d, element: %d, selected item: %d\n", 
	 iret, el, pos);
  return iret;
} /* end iindex */


void InitDataSets(struct BeamlineType *bl, char *mainpickname)   
     /* initialisiert die globalen Variablen */
     /* last mod. Uwe 21.1.97 		*/
{
#ifdef LOGFILE 
  CheckUser(logfilename, "Phase");                      /* user logfile  */
#endif

  if (GetPHASE(&bl->filenames, mainpickname) != 1)           /* filenamen */
    {  
      InitPHASE(&bl->filenames);   				/* set default names */
      PutPHASE(&bl->filenames, mainpickname);          	/* write names */   
    }

    /* neu beamline pointer initialisieren 7.6.96*/
  bl->ElementList= NULL;                       /* 15.12.99 */
  bl->raysout    = NULL;
  bl->RTSource.SourceRays= NULL;
  bl->beamlineOK= 0; 
  bl->tp= NULL;
#ifndef QTGUI
  ginitdatset(&GDefDat);           /* init defaults */
  minitdatset(&MDefDat);
#endif

  ReadBLFile(bl->filenames.beamlinename, bl);
#ifndef QTGUI
  strncpy(bl->filenames.pssourcename, bl->src.so6.fsource6, MaxPathLength);  
#endif
#ifndef QTGUI
  grdatstruct.status= 0;
  SetGrDatStruct(bl->filenames.imageraysname, bl, &grdatstruct);  
#endif
  /* PHASEgraf.c */
  /*   optistructure.fileliste= NULL;     */
#ifdef DEBUG
  printf("InitDatSets end\n");   
#endif  
}

void InitOptiBox1(char *pickname)   
{
  printf("dummy %s\n", pickname);
}

void InitPHASE(struct PHASEset *x)                   /* set defaults */
{
  strncpy(x->matrixname,      D0matrixname, MaxPathLength);
  strncpy(x->mapname,         D0mapname, MaxPathLength);    
  strncpy(x->sourceraysname,  D0sourceraysname, MaxPathLength);       
  strncpy(x->imageraysname,   D0imageraysname, MaxPathLength);	   
  strncpy(x->intersecname,    D0intersecname, MaxPathLength);
  strncpy(x->geometryname,    D0geometryname, MaxPathLength);   
  strncpy(x->elementname,     D0elementname, MaxPathLength);        
  strncpy(x->sourcepckname,   D0sourcepckname, MaxPathLength);       
  strncpy(x->elementpckname,  D0elementpckname, MaxPathLength);
  strncpy(x->geometrypckname, D0geometrypckname, MaxPathLength); 
  strncpy(x->pssourcename,    D0pssourcename, MaxPathLength);   
  strncpy(x->plotpsname,      D0plotpsname, MaxPathLength);   
  strncpy(x->printpclname,    D0printpclname, MaxPathLength);   
  strncpy(x->optipckname,     D0optipckname, MaxPathLength);   
  strncpy(x->beamlinename,    "SGM.PHASE", MaxPathLength); 
  strncpy(x->opresname,       "opti_out.dat", MaxPathLength); 
  //  strncpy(x->minname,         "minuit.inp", MaxPathLength);   
}
   
void PutPHASE(struct PHASEset *x, char *mainpickname)  /* write mainpickfile */
{                              
  FILE *f;
  int version= 20121105; /* 20110814; */
  printf("putphase: write filenames\n");

  if ((f= fopen(mainpickname, "w")) == NULL)
    {
      fprintf(stderr,"\afatal Error: write %s\n", mainpickname);
      exit(-1);
    } else 
      {
	fprintf(f,"%s %d\n", MainPickFileHeader, version);
#ifdef before_20110814
        fprintf(f,"%s\n", x->matrixname); 
        fprintf(f,"%s\n", x->mapname);    
 	fprintf(f,"%s\n", x->sourceraysname);       
 	fprintf(f,"%s\n", x->imageraysname);	   
 	fprintf(f,"%s\n", x->intersecname);
 	fprintf(f,"%s\n", x->geometryname); 
        fprintf(f,"%s\n", x->elementname); 
        fprintf(f,"%s\n", x->sourcepckname);
        fprintf(f,"%s\n", x->geometrypckname);  
        fprintf(f,"%s\n", x->elementpckname);  
        fprintf(f,"%s\n", x->pssourcename);    
        fprintf(f,"%s\n", x->plotpsname);  
        fprintf(f,"%s\n", x->printpclname);   
        fprintf(f,"%s\n", x->optipckname);   
#endif
        fprintf(f,"%s\n", x->beamlinename);
#ifdef before_20110814
	fprintf(f,"%s\n", x->so4_fsource4a);
	fprintf(f,"%s\n", x->so4_fsource4b);
	fprintf(f,"%s\n", x->so4_fsource4c);
	fprintf(f,"%s\n", x->so4_fsource4d);
	fprintf(f,"%s\n", x->so6_fsource6);
	fprintf(f,"%s\n", x->opresname);
	//fprintf(f,"%s\n", x->minname);
#endif
       	fclose(f);  
      }
}    /* end putphase */	


void SetDefaultParameter(struct BeamlineType *bl) 
     /* setzt defaults fuer Parameterbox */ 
     /* Uwe 21. 10. 96 */ 
     /* Stand 17. 2. 97 */ 
{
  bl->BLOptions.epsilon= 1e-5; 
  bl->BLOptions.ifl.iord= 4; 
  bl->BLOptions.PSO.intmod= 1;
  bl->BLOptions.PSO.PSSource.yhard=  0;
  bl->BLOptions.PSO.PSSource.dyhard= 0;
  bl->BLOptions.PSO.PSSource.zhard=  0;
  bl->BLOptions.PSO.PSSource.dzhard= 0; 
  bl->BLOptions.PSO.PSSource.sigy=   0.03;
  bl->BLOptions.PSO.PSSource.sigdy=  4e-5;
  bl->BLOptions.PSO.PSSource.sigz=   0.3;
  bl->BLOptions.PSO.PSSource.sigdz=  4e-5; 
  bl->BLOptions.PSO.ndyfix=          30;
  bl->BLOptions.PSO.dyminfix= -1e-2;
  bl->BLOptions.PSO.dymaxfix=  1e-2;
  bl->BLOptions.PSO.ndzfix=    30;
  bl->BLOptions.PSO.dzminfix= -1e-2;
  bl->BLOptions.PSO.dzmaxfix=  1e-2;

  /*bl->BLOptions.xi.itery0=  5;*/
  bl->BLOptions.xi.ianzy0=  15;
  /*  bl->BLOptions.xi.imaxy=   25;*/
  /*bl->BLOptions.xi.fracy=   0.7;*/
  /*bl->BLOptions.xi.frac1y=  0.2;*/

  /*bl->BLOptions.xi.iterz0=  5;*/
  bl->BLOptions.xi.ianzz0=  15;
  /*bl->BLOptions.xi.imaxz=   25;*/
  /*bl->BLOptions.xi.fracz=   0.7;*/
  /*bl->BLOptions.xi.frac1z=  0.2;*/

  printf("\nDefaults sind nicht mehr aktuell!\n");
 
} /* end SetDefaultParameter  */








/* initialisiert ein indexfeld mit n Integern die als variable Liste  	*/
/* eingelesen werden 	  						*/ 
void SetIndexField(int *field, int n,...)  
{
  va_list v;
  int *ip; 
   
  ip= field; 
  va_start(v, n);     		/* n- letzter Pflichtparameter */
  for (; n> 0; n--)
    *ip++= va_arg(v, int);
  va_end(v);     
} /* end SetIndexField */


#ifndef QTGUI
void GeneratePrintDataFile(char *name)
{
  FILE *pdf;
  int i;

  if ((pdf= fopen(name, "w+")) == NULL)
    {
      fprintf(stderr, "GeneratePrintDataFile: error: open file %s\n", name); 
      exit(-1);
    }

  for (i= 0; i< 80; i++) fprintf(pdf,"*");  
  fputs("\nInput Data \n", pdf);
  for (i= 0; i< 80; i++) fprintf(pdf,"*");  


  fprintf(pdf, "\n\nMain Data File (Version higher 0.902: %s\n\n", 
	  Beamline.filenames.beamlinename);
  gpd(Beamline.filenames.beamlinename, pdf);   
 
  for (i= 0; i< 80; i++) fprintf(pdf,"*");    

  fprintf(pdf, "\n\nSource File: %s\n\n", Beamline.filenames.sourcepckname);
  gpd(Beamline.filenames.sourcepckname, pdf);    
  for (i= 0; i< 80; i++) fprintf(pdf,"*");    
  fprintf(pdf, "\n\nGeometry File: %s\n\n", Beamline.filenames.geometrypckname);
  gpd(Beamline.filenames.geometrypckname, pdf); 
  for (i= 0; i< 80; i++) fprintf(pdf,"*");  
  fprintf(pdf, "\n\n\n\nopt. Element File: %s\n\n", Beamline.filenames.elementpckname);
  gpd(Beamline.filenames.elementpckname, pdf);

 
  for (i= 0; i< 80; i++) fprintf(pdf,"*");  
  /*   fprintf(pdf, "\nParameter File: %s\n\n", PHASESet.pssourcename);
       gpd(PHASESet.pssourcename, pdf); */   
  fclose(pdf);
}
#endif

/*80 in Maxpathlengt 16.11.01 UF*/
void gpd(char *ifname, FILE *af)  
{
  char puffer[MaxPathLength];
  FILE *ifile;

  if ((ifile= fopen(ifname, "r")) == NULL)
    {
      fprintf(stderr,"gpd: error: open file %s\n", ifname); 
      /* 11.1.2000       exit(-1); */
    }  
  else
    {  
      while (!feof(ifile))
	{
	  fgets(puffer, MaxPathLength, ifile); fputs(puffer, af);
	}
      fclose(ifile);
    }
}


/************************************************************************/
void writemapc(char *fname, char *header, int iord, 
               double *ypc1, double *zpc1, double *dypc,   double *dzpc,
	       double *wc,   double *xlc,  double *xlen1c, double *xlen2c)   
/************************************************************************/
/* schreibt die Transformationskoeffizienten auf ein file       	*/
/* Anpassung an SEVEN_ORDER 8.7.2011 UF                                 */     
/************************************************************************/
{
  FILE *f;
  int i, j, k, l, index;
  
  if ((f= fopen(fname, "w+")) == NULL)
    {
      fprintf(stderr, "writemapc: error: open file %s\n", fname); exit(-1);   
    }    
  fprintf(stdout, "writemapc: write transformation map to: %s\n", fname);
  fprintf(f, "#\n# %s\n#\n", header);
  fprintf(f,
	  "i j k l          ypc             zpc            dypc            dzpc\n");
  for (i= 0; i <= iord; i++)
    for (j= 0; j <= iord; j++)
      for (k= 0; k <= iord; k++)
	for (l= 0; l <= iord; l++)
	  if((i+j+k+l) <= iord)
	    {
#ifdef SEVEN_ORDER
	      index=i+ j*8+ k*64 + l*512;
#else
	      index=i+ j*5+ k*25 + l*125;
#endif
	      /*     printf("%d\n", index); */
	      fprintf(f, "%d %d %d %d % 15.5E % 15.5E % 15.5E % 15.5E\n", 
                      i, j, k, l, ypc1[index], zpc1[index],
		      dypc[index], dzpc[index]);
	    }
  fprintf(f, "\n\n\n");
  fprintf(f,
	  "i j k l          wc              xlc            xlen1c          xlen2c\n");
  for (i= 0; i <= iord; i++)
    for (j= 0; j <= iord; j++)
      for (k= 0; k <= iord; k++)
	for (l= 0; l <= iord; l++)
	  if((i+j+k+l) <= iord)
	    {
#ifdef SEVEN_ORDER
	      index=i+ j*8+ k*64 + l*512;
#else
	      index=i+ j*5+ k*25 + l*125;
#endif
	    
	      fprintf(f, "%d %d %d %d % 15.5E % 15.5E % 15.5E % 15.5E\n", 
                      i, j, k, l, wc[index], xlc[index],
		      xlen1c[index], xlen2c[index]);
	    }
  fclose(f);
}	
/* ******** end writemapc() ************************************** */




/* setzt den sourcetype in der struktur abhanegig von einem Schalter */ 
/* UF 28.11.06 */
void InitSourceType(struct BeamlineType *bl, int widget_num)
{
  int sou;

  switch (widget_num) 
    {
    case kESDipolSourceButton: 	   sou= 'D'; break;
    case kESPointSourceButton: 	   sou= 'o'; break;
    case kESRingSourceButton: 	   sou= 'R'; break;
    case kESUndulatorSourceButton: sou= 'U'; break;  
    case kESUndulatorSISButton:    sou= 'L'; break;  /*23.11.98 UF*/
    case kESUndulatorSIMButton:    sou= 'M'; break;  
    case kESundulatorSourceButton: sou= 'u'; break;
    case kESUndulatorButton:       sou= 'G'; break;
    case kESSR2Button: 		   sou= 'S'; break;  
    case kESPhaseSpaceButton:	   sou= 'P'; break;  
    case kESPhaseSpaceImageButton: sou= 'I'; break; 
    case kESFileButton:            sou= 'F'; break;
    case kESDefaults:
    case kESourceMenuButton:	   sou= bl->RTSource.QuellTyp; 
      break;
    case kESRayTraceButton:
    default : 			   sou= 'H'; 
    }
  if (sou == 0) sou= 'H'; 
  printf("InitSourceType: new: %c, old: %c, num: %d, int(old): %d\n", 
	 sou, bl->RTSource.QuellTyp, widget_num, bl->RTSource.QuellTyp);
  bl->RTSource.QuellTyp= sou;

  

} /* end InitSourceType */

int CheckBLOK(int blok, int target, char *message)
{
  int ret;
  ret= 1;
  if ((blok & target) != target)
    {
      fprintf(stderr, "%s beamline is not OK: 0x%X & 0x%X = 0x%X\n", 
	      message, blok, target, (blok & target)); 
      if (((target & sourceOK) > 0) && ((blok & sourceOK) == 0)) 
	fprintf(stderr, "  %s\n", "RT source not defined!");
      if (((target & mapOK) > 0) && ((blok & mapOK) == 0)) 
	fprintf(stderr, "  %s\n", "matrix and map not defined!");
      if (((target & resultOK) > 0) && ((blok & resultOK) == 0)) 
	fprintf(stderr, "  %s\n", "result not defined!");
      if (((target & elementOK) > 0) && ((blok & elementOK) == 0)) 
	fprintf(stderr, "  %s\n", "optical element not defined!");
      /*if (((target & geometryOK) > 0) && ((blok & geometryOK) == 0))
	fprintf(stderr, "  %s\n", "geometry of optical element not defined!");*/
      if (((target & pstsourceOK) > 0) && ((blok & pstsourceOK) == 0)) 
	fprintf(stderr, "  %s\n", "PST source not defined!");
      if (((target & pstimageOK) > 0) && ((blok & pstimageOK) == 0))
	fprintf(stderr, "  %s\n", "PST image plane not defined (in Source menu)!");
      ret= 0;
    }
  return ret;
}

void ginitdatset(struct gdatset *x)
{
   int i;
        
   x->theta0	= 88.0;     
   x->r		= 10000;
   x->rp	= 1000;
   for (i= 0; i< 5; i++) 
     x->xdens[i] = 0; 
   //x->lambdag  	 = 0;  
   //x->dlambda     = 0; 
   //x->dlambdaflag = 0; 
   x->inout	= 1;  
   x->iflag	= 0; 
   x->azimut    = 0;
}

void minitdatset(struct mdatset *x)
{
         x->r1		= 10000;     
	 x->r2		= 1000;
	 /*x->alpha	= 88;*/                           
	 x->rmi		= 2000;
	 x->rho		= 2000;           
      	 x->iflagmi	= 0;  
         x->w1          = -100 ;
	 x->w2          = 100;
	 x->l1          = -10;
	 x->l2          = 10;
	 x->slopew      = 0.1;
	 x->slopel      = 1;
	 x->du= x->dw= x->dl= x->dRu= x->dRw= x->dRl= 0.0;
	 x->Art= 188;
}

void initdatset(struct datset *x, struct BeamlineType *bl)
{
  int i;
  
  struct UndulatorSourceType *up;
  struct DipolSourceType     *dp;
  struct PointSourceType     *pp;
  struct HardEdgeSourceType  *hp;     
  struct SRSourceType        *sp;  
  struct PSImageType	     *ip;
  struct FileSourceType      *fp;
  
  if (bl->RTSource.QuellTyp != bl->RTSource.QuellTyp_old) 
    {
      x->itrans	= 1;     
      x->idir  	= 1;
      x->imodus	= 1;
      x->disty 	= 0.2;   
      x->iheigh	= 3;
      x->distz 	= 0.5;
      x->iwidth	= 3;
      x->divy  	= 1.0;
      x->idivy 	= 11;
      x->divz  	= 1.0;
      x->idivz 	= 11;
      x->intmod	= 2;
      x->disty1	= -0.1;
      x->disty2	= 0.1;        
      x->distz1	= -0.1;        
      x->distz2	= 0.1;        
      x->yi    	= 1.0;            
      x->zi    	= 1.0;            
      x->dyi   	= 1.0;           
      x->dzi   	= 1.0;           
      x->w     	= 1.0;            
      x->xl    	= 1.0; 
      x->isourcefile = 0;  
      x->xlam_test   = 10;  
      
      x->sigmay  = 0.05;
      x->sigmayp = 1500;
      x->ymin	 = -30;
      x->ymax	 = 30;    
      x->sigmaz	 = 0.05;  
      x->sigmazp = 1500;  
      x->zmin	 = -30;	  
      x->zmax	 = 30;    
      x->epsilon = 1e-4;
      x->fracy 	= 0.005;
      x->frac1y	= 0.3;
      x->fracz	= 0.005;
      x->frac1z	= 0.3;
      x->iord	= 4;
      x->isrcy 	= 1;
      x->isrcdy	= 1;
      x->inumy	= 51;
      x->itery0	= 12;
      x->ianzy0	= 150;
      x->imaxy	= 200;
      x->isrcz	= 1;
      x->isrcdz	= 1;
      x->inumz	= 51;
      x->iterz0	= 12;                
      x->ianzz0	= 150;
      x->imaxz	= 200;
      
      x->SR2out.y= x->SR2out.z= x->SR2out.dy= x->SR2out.dz= 0.0;  
      
      bl->RTSource.raynumber= 1000;
      switch(bl->RTSource.QuellTyp)
	{
	case 'U': 
	case 'u':
	  up= (struct UndulatorSourceType *)bl->RTSource.Quellep; 
	  up->length= 3800.0;
	  up->lambda= 12.4e-6;  
	break;   
	case 'L': 
	case 'M':
	  up= (struct UndulatorSourceType *)bl->RTSource.Quellep; 
	  up->length= 3800.0;
	  up->lambda= 12.4e-6;
	  up->deltaz= 0.0;
	break;
	case 'D': dp=(struct DipolSourceType *)bl->RTSource.Quellep; 
	  dp->sigy		= 0.093;  
	  dp->sigdy	        = 1.;  
	  dp->sigz        	= 0.05;
	  dp->dz          	= 4.0;
	  break;  
	case 'o': pp=(struct PointSourceType *)bl->RTSource.Quellep; 
	  pp->sigy	= 0.093;  
	  pp->sigdy	= 1.;  
	  pp->sigz      = 0.05;
	  pp->sigdz     = 1.0;
	  break;  
	case 'S': sp= (struct SRSourceType *)bl->RTSource.Quellep;
	  sp->y	        =0.1;  
	  sp->dy	=0.1;  
	  sp->z	        =0.1;  
	  sp->dz	=0.1; 
	  break;   
	case 'I': ip= (struct PSImageType*)bl->RTSource.Quellep; 
	  ip->ymin	= -1.0e-1;  
	  ip->ymax	=  1.0e-1;  
	  ip->zmin	= -1.0e-1;  
	  ip->zmax	=  1.0e-1;
	  ip->iy   =   15;
	  ip->iz   =   15;
	  break;   
	case 'H': 
	  hp= (struct HardEdgeSourceType *)bl->RTSource.Quellep; 
	  bl->RTSource.QuellTyp= 'H';
	  hp->disty	= .1;  
	  hp->iy 		= 3;   
	  hp->distz	= .2;  
	  hp->iz		= 3;   
	  hp->divy	= 1.;  
	  hp->idy		= 7;   
	  hp->divz	= 4.;  
	  hp->idz		= 7;   
	  bl->RTSource.raynumber= hp->iy * hp->iz * hp->idy * hp->idz;
	  break;   
	case 'F':
	  fp= (struct FileSourceType *)bl->RTSource.Quellep;
#ifndef QTGUI

	  strncpy(fp->filename, Beamline.filenames.sourceraysname, MaxPathLength);

#endif
	  /* we may add a test if the file exists */
	break;   
	}  /* end case */
      bl->RTSource.QuellTyp_old =  bl->RTSource.QuellTyp;
      printf("initdatset: put defaults\n");
    } else  printf("initdatset: same source- no defaults set\n");
  /* 24.6.96 */
  printf("initdatset.c: set  idir, iord, epsilon to defaults\n");
  bl->BLOptions.SourcetoImage= x->idir; 
  bl->BLOptions.ifl.iord=      x->iord;
  bl->BLOptions.epsilon=       x->epsilon;  
}

/* 1204 initializes the pointers in source4c */
void init_posrc(struct source4c *sp)
{
  sp->zeyre= NULL;
  sp->zeyim= NULL;
  sp->zezre= NULL;
  sp->zezim= NULL;
  sp->gridx= NULL;
  sp->gridy= NULL;
} /* end init_posrc() */


/* end of file phasec.c */     
                           
