 /* File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseqt/unwrap_phase.h */
 /* Date      : <26 Mar 14 11:59:12 flechsig>  */
 /* Time-stamp: <26 Mar 14 15:22:20 flechsig>  */
 /* Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

 /* $Source$  */
 /* $Date$ */
 /* $Revision$  */
 /* $Author$  */

#ifndef UNWRAP_PHASE_H
#define UNWRAP_PHASE_H

#define MYPI    3.141592654
#define TWOMYPI 6.283185307 

#define swap(x,y) {EDGE t; t=x; x=y; y=t;}
#define order(x,y) if (x.reliab > y.reliab) swap(x,y)
#define o2(x,y) order(x,y)
#define o3(x,y,z) o2(x,y); o2(x,z); o2(y,z)

typedef enum {yes, no} yes_no;

//pixel information
struct PIXEL
{
  //int x;					//x coordinate of the pixel
  //int y;					//y coordinate
  int          increment;			//No. of 2*pi to add to the pixel to unwrap it
  int          number_of_pixels_in_group;	//No. of pixels in the pixel group
  double       value;			        //value of the pixel
  double       reliability;
  int          group;				//group No.
  int          new_group;
  struct PIXEL *head;		// pointer to the first pixel in the group in the linked list
  struct PIXEL *last;		// pointer to the last pixel in the group
  struct PIXEL *next;		// pointer to the next pixel in the group
};

// the EDGE is the line that connects two pixels.
// if we have S PIXELs, then we have S horizental edges and S vertical edges
struct EDGE
{    
  double reliab;		// reliabilty of the edge and it depends on the two pixels
  PIXEL  *pointer_1;		// pointer to the first pixel
  PIXEL  *pointer_2;		// pointer to the second pixel
  int    increment;		// No. of 2*pi to add to one of the pixels to unwrap it with respect to the second 
}; 

// prototypes
double wrap(double);

EDGE *partition(EDGE *, EDGE *, double);

int find_wrap(double, double);

void calculate_reliability(double *, PIXEL *, int, int);
void gatherPIXELs(EDGE *, int, int);
void horizentalEDGEs(PIXEL *, EDGE *, int, int);
void initialisePIXELs(double *, PIXEL *, int, int);
void Mix(EDGE *, int *, int *, int);
void quick_sort(EDGE *, int);
void quicker_sort(EDGE *, EDGE *);
void returnImage(PIXEL *, double *, int, int);
void sort(EDGE *, int *, int);
void unwrapImage(PIXEL *, int, int);
void unwrap_phase(double *, int, int);
void verticalEDGEs(PIXEL *, EDGE *, int, int);

yes_no find_pivot(EDGE *, EDGE *, double *);

#endif
// end
