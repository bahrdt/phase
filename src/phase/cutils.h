/*   File      : /afs/psi.ch/user/f/flechsig/phase/src/phase/cutils.h */
/*   Date      : <08 Apr 04 15:05:08 flechsig>  */
/*   Time-stamp: <06 Jul 11 13:13:10 flechsig>  */
/*   Author    : Uwe Flechsig, flechsig@psi.ch */

/*   $Source$  */
/*   $Date$ */
/*   $Revision$  */
/*   $Author$  */

#ifndef CUTILS_H
#define CUTILS_H    

#define max(a,b) (((a) > (b)) ? (a) : (b))
#define min(a,b) (((a) < (b)) ? (a) : (b))

#define		FASTNULL		1.0e-15

                                              /* linux */
#define 	logfilename 		"/tmp/phaseuser.log" 
typedef struct FortranString
{   
  char *string;
  int length;
} FString; 


char    *delversion(char *); /* entfernt Versionsnummer von VMS- Filenamen */
char    *FnameBody(char *);  /* holt Rumpf von VMS- - Filenamen            */
char    *PrependEnv(char* , char *);
void 	 beep(int); 
void	 CheckUser(char *, char *); 
int 	 CheckFileHeader(FILE *, char *, int *);   
FString *CreateFString(FString *, char *); 
double   uRandom(double), RVZ();   
   
#endif  /*  CUTILS_H */     
/* end /home/pss060/sls/flechsig/phase/src/phase/cutils.h */
