 /* File      : /afs/psi.ch/user/f/flechsig/phase/src/fkoempi/fkoempi.c */
 /* Date      : <01 Apr 14 09:15:01 flechsig>  */
 /* Time-stamp: <01 Apr 14 09:15:15 flechsig>  */
 
 /* $Source$  */
 /* $Date$ */
 /* $Revision$  */
 /* $Author$  */
/************************************************************************
 fkoe.c
 
 Fresnel-Kirchhoff integration over optical element
 implemented for MPI
*************************************************************************/

#include <mpi.h>
#include <stdio.h>
#include <math.h>

#define MAXDIM 2048

#define PARFNAME    "fkoe.par"

#define BASEOFNAME   "fout"

struct extends
{
  double y_min;
  double y_max;
  double z_min;
  double z_max;
};

struct complex
{
  double re, im;
};

struct complex ey0[MAXDIM][MAXDIM];
struct complex ez0[MAXDIM][MAXDIM];
struct complex ey1[MAXDIM][MAXDIM];
struct complex ez1[MAXDIM][MAXDIM];
double sy0[MAXDIM], sz0[MAXDIM];
double sy1[MAXDIM], sz1[MAXDIM];

double surf[MAXDIM][MAXDIM];

int rank;

int mode;
int ny0, nz0;
int ny1, nz1;
char surffilename[256];
char srcfilenames[4][256];
double dist, dista;
double angle, xlam;  
double cc;
double dz0, dy0;

struct extends e1_extends, s_extends;
//double z1_min, z1_max, y1_min, y1_max;


void all_load_parameters(const char *parfname);
void all_load_fields();
void master_save_fields(const char *baseofname, int ny, int nz);
void slave_load_surface(const char *surffilename, int *ny, int *nz, double sy[], double sz[]);

void build_dest_axis(const struct extends *e, int ny, int nz, double sy[], double sz[]);

void master_propagate(int nslaves);
void slave_propagate_1(double angle);
void slave_propagate_2(double angle);
void slave_propagate_10();


/************************************************************************
 initialize master and slave threads, 
 do processing, combine and finalize
*************************************************************************/
int main(int argc, char *argv[])
{
  int i,j;
  int res, nthreads;
  double z0_min, z0_max, y0_min, y0_max; 
  
  // global   
  
  res = MPI_Init(&argc, &argv);
  if (res != 0)
  {
    fprintf(stderr, "Could not initialize OpenMPI!\n"); 
    return -1;
  }
  
  MPI_Comm_size(MPI_COMM_WORLD, &nthreads);
  if (nthreads < 2)
  {    
    fprintf(stderr, "Master/slave approach needs at least two processes!\n");
    MPI_Finalize();
    return -1;
  }        
  
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    
  // load and initialize data 
  all_load_parameters(PARFNAME);
  all_load_fields(s_extends);  
    
  switch (mode)
  {
    case 10:
      build_dest_axis(&e1_extends, ny1, nz1, sy1, sz1);
    break;
    
    case 1:
      slave_load_surface(surffilename, &ny1, &nz1, sy1, sz1);            
    break;      
    
    case 2:
      slave_load_surface(surffilename, &ny0, &nz0, sy0, sz0);      
      build_dest_axis(&e1_extends, ny1, nz1, sy1, sz1);            
    break;      
        
    case 3:
      exit(-2); // not yet 
      //slave_load_surface(surffilename, &ny1, &nz1, sy1, sz1);      
      
    break;      
    
    default:
      fprintf(stderr, "Unsupported mode %d!\n", mode);
      MPI_Finalize();
      return -1;
    break;      
  }
  
  // determine parameters for source field
  xlam=xlam*1.0e-6;
  cc=(2.0*M_PI)/xlam;    
  z0_min = sz0[0]; z0_max = sz0[nz0-1];
  y0_min = sy0[0]; y0_max = sy0[ny0-1];  
  dz0 = (z0_max-z0_min)/(nz0-1); 
  dy0 = (y0_max-y0_min)/(ny0-1); 
   
  // start master/slave specific tasks
  if (rank==0)
  {
    int nslaves;
    
    printf("M: Starting FKOE with %d processes\n", nthreads); 
  
    nslaves = nthreads-1;
  
    master_propagate(nslaves);
    master_save_fields(BASEOFNAME, ny1, nz1);            
    
    printf("M: done\n");
  }
  else
  {    
    
    switch (mode)
    {
      case 10:        
        slave_propagate_10();
      break;
    
      case 1:
        slave_propagate_1(angle);
      break;      
    
      case 2:
        slave_propagate_2(angle);
      break;      
    }        
  }
   
  
  MPI_Finalize();
  return 0;
}

/************************************************************************
 read in parameter file and init global variables
*************************************************************************/
void all_load_parameters(const char *parfname)
{
  int t;
  FILE *fp;
  double angle_deg;
  
  fp = fopen(parfname, "r");
  if (!fp)
  {
    fprintf(stderr, "Could not open parameter file %s\n", parfname);
    MPI_Finalize();
    exit (-1);    
  }
    
  // parse
  for (t=0; t<4; t++)
    fscanf(fp, "%255s %*[^\n]", srcfilenames[t]);
  
  fscanf(fp, "%d %*[^\n]", &mode);
  fscanf(fp, "%lf,%lf %*[^\n]", &dist, &dista);
  fscanf(fp, "%lf %*[^\n]", &angle_deg);
  fscanf(fp, "%lf %*[^\n]", &xlam);
  
  fscanf(fp, "%lf %lf %*[^\n]", &e1_extends.y_min, &e1_extends.y_max);
  fscanf(fp, "%d %*[^\n]", &ny1);
  
  fscanf(fp, "%lf %lf %*[^\n]", &e1_extends.z_min, &e1_extends.z_max);
  fscanf(fp, "%d %*[^\n]", &nz1);
  
  fscanf(fp, "%255s %*[^\n]", surffilename);
  
  
  angle = angle_deg*M_PI/180.0;
  
  fclose(fp);   
}


/************************************************************************
 read in EM-field data
*************************************************************************/
void all_load_fields()
{
  FILE *fp[4];
  int t, i, j;
  
  // open the four field files
  for (t=0; t<4; t++)
  {
    fp[t] = fopen(srcfilenames[t], "r");
    if (!fp[t])
    {
      fprintf(stderr, "Could not open file %s\n", srcfilenames[t]);
      MPI_Finalize();
      exit (-1);    
    }
    
    // determine grid size/increase file pointer
    fscanf(fp[t], "%d %d\n", &nz0, &ny0);
  } 
  
  // read in values
  for (j=0; j<ny0; j++)
    for (i=0; i<nz0; i++)
    {
      fscanf(fp[0], "%lf %lf %lf\n", &sz0[i], &sy0[j], &ey0[j][i].re);
      fscanf(fp[1], "%*lf %*lf %lf\n", &ey0[j][i].im);
      fscanf(fp[2], "%*lf %*lf %lf\n", &ez0[j][i].re);
      fscanf(fp[3], "%*lf %*lf %lf\n", &ez0[j][i].im);    
    }
      
  for (t=0; t<4; t++)
    fclose(fp[t]);  
}

/************************************************************************
 read in surface profile
*************************************************************************/
void slave_load_surface(const char *surffilename, int *ny, int *nz, double sy[], double sz[])
{
  FILE *fp;
  int i, j;
  
  // open the surface file
  fp = fopen(surffilename, "r");
  if (!fp)
  {
    fprintf(stderr, "Could not open file %s\n", surffilename);
   
    //TODO: tell master load failed
    
    MPI_Finalize();
    exit (-1);    
  }
    
    // determine surface grid size
  fscanf(fp, "%d %d\n", nz, ny);
  
  // read in values
  for (j=0; j < *ny; j++)
    for (i=0; i < *nz; i++)
    {
      fscanf(fp, "%lf %lf %lf\n", &sz[i], &sy[j], &surf[j][i]);      
    }
      
  
  fclose(fp);  
}

/************************************************************************
 write EM-field data to files
*************************************************************************/
void master_save_fields(const char* baseofname, int ny, int nz)
{  
  FILE *fp[4];
  int i,j,t;
  const char *extensions[4] = {"eyrec", "eyimc", "ezrec", "ezimc"};

  
  for (t=0; t<4; t++)
  {
    char fname[256];
      
    snprintf(fname, 256, "%s-%s", baseofname, extensions[t]);

    fp[t] = fopen(fname, "w+");
    if (!fp[t])
    {
      fprintf(stderr, "Could not create/write to file %s\n", fname);
      
      //TODO: terminate slaves first
      
      MPI_Finalize();
      exit (-1);    
    }
    
    fprintf(fp[t], "%12d%12d\n", nz, ny);
  }
    
  // write the values to all four fields
  for (j=0; j<ny; j++)
    for (i=0; i<nz; i++)
    {
      fprintf(fp[0], "%e %e %e \n", sz1[i], sy1[j], ey1[j][i].re);
      fprintf(fp[1], "%e %e %e \n", sz1[i], sy1[j], ey1[j][i].im);
      fprintf(fp[2], "%e %e %e \n", sz1[i], sy1[j], ez1[j][i].re);
      fprintf(fp[3], "%e %e %e \n", sz1[i], sy1[j], ez1[j][i].im);
    }
    
  for (t=0; t<4; t++)
    fclose(fp[t]);
}

/************************************************************************
 interpolate and initialize the axis scales for the image plane
*************************************************************************/
void build_dest_axis(const struct extends *e, int ny, int nz, double sy[], double sz[])
{
  int i,j;
  double dy, dz;
  
  // calculate parameters for destination field
  dz = (e->z_max-e->z_min)/(nz-1);
  dy = (e->y_max-e->y_min)/(ny-1);  
  
  for (j=0; j<ny; j++)
  {
    sy[j] = e->y_min + j*dy;
    for (i=0; i<nz; i++)
    {
      sz[i] = e->z_min + i*dz;
    }
  }
}


/************************************************************************
 distribute tasks to the slave threads to process "line nr" j (i.e. y)    
*************************************************************************/
void master_propagate(int nslaves)
{
  int i,j = 0;
  int *lines;
  
  
  lines = malloc(nslaves * sizeof(int));    
    
    do 
    {
      int n, nrtasks;
      
      // distribute tasks 
      nrtasks = nslaves;
      if ((j+nrtasks) > ny1) nrtasks = ny1-j;
            
      for (n=0; n<nrtasks; n++)
      {
        lines[n] = j;
                
        //printf("M: assign task(%d) to process %d\n", lines[n], n+1);
        MPI_Send(&lines[n], 1, MPI_INT, n+1, 0, MPI_COMM_WORLD);
        
        j++;
      }
      
      // wait for tasks to report results
      for (n=0; n<nrtasks; n++)
      {
        int c;
        struct complex vals[2*nz1];
        
        MPI_Recv(vals, nz1*2*2, MPI_DOUBLE, n+1, 1, MPI_COMM_WORLD, NULL);

        //printf("M: got result from process %d (task %d)\n", n+1, lines[n]);
        
        // copy obtained line to target field
        //printf("M: [%d] = (%.2f,%.2f)\n", 0, vals[0].re*1000, vals[0].im*1000);
        for (c=0; c<nz1; c++)
        {          
          ey1[lines[n]][c] = vals[c];
          ez1[lines[n]][c] = vals[c+nz1];
        }
        
        //for (c=0; c<NZ1; c++)
          //printf("M: result(%d)[%d] = (%.2f, %.2f)\n", n+1, c, vals[c].re, vals[c].im);
      }
      
      printf("j = %d\n", j);
    } while (j<ny1);
    
    // tell slaves to exit
    for (i=0; i<nslaves; i++)
    {
      int nexit = -1;
      MPI_Send(&nexit, 1, MPI_INT, i+1, 0, MPI_COMM_WORLD);
    }
             
  free(lines);
}


/************************************************************************
 receive tasks from Master thread and send result (a line) back to Master
 mode 10: free space propagation without optical element
*************************************************************************/
void slave_propagate_10()
{
  int i, tag, src;
    int j;
    double fact0;
    
    fact0 = (dz0*dy0)/xlam;
      
    // slave thread
    // receive and process until getting j=-1
    do 
    {
      MPI_Recv(&j, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, NULL);
    
      if (j != -1)
      {
        int i;
        int k,l;
        struct complex vals[2*nz1];
        
        //printf("S[%d]: got task(%d)\n", rank, j);
          
                
        //calculate_line
        for (i=0; i<nz1; i++)
        {
          struct complex val_y = {0.0, 0.0}, val_z = {0.0, 0.0};
          double phase;
          struct complex fact;
                    
          for (l=0; l<ny0; l++)
            for (k=0; k<nz0; k++)
            {
              struct complex y = ey0[l][k];
              struct complex z = ez0[l][k];                           
          
              //double abs_
              double dist1 = sqrt(dist*dist + (sy0[l]-sy1[j])*(sy0[l]-sy1[j]) + 
                               (sz0[k]-sz1[i])*(sz0[k]-sz1[i])) - fabs(dist);
            
                               
              if (dist > 0)
                phase = dist1*cc;
              else
                phase = -dist1*cc;
         
              fact.re = fact0*cos(phase)/(dist+dist1);
              fact.im = fact0*sin(phase)/(dist+dist1);
                  
              // y-polarized
              val_y.re += y.re*fact.re-y.im*fact.im;
              val_y.im += y.im*fact.re+y.re*fact.im;
              
              // z-polarized
              val_z.re += z.re*fact.re-z.im*fact.im;
              val_z.im += z.im*fact.re+z.re*fact.im;
            }
 
            vals[i] = val_y;
            vals[i+nz1] = val_z;
          }
                            
        //printf("S[%d]: [%d] = (%.2f,%.2f)\n", rank, 0, vals[0].re*1000, vals[0].im*1000);
        MPI_Send(vals, nz1*2*2, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD);

        //printf("S[%d]: sent result for task(%d)\n", rank, j);
      }
      else
        printf("S[%d]: got exit signal\n", rank);        
    } while(j != -1);
    
      printf("S[%d]: done\n", rank);   
}

/************************************************************************
 receive tasks from Master thread and send result (a line) back to Master
 mode 1: free space propagation from source plane to optical element
*************************************************************************/
void slave_propagate_1(double angle)
{
  int i, tag, src;
    int j;
    double fact0;
    
    
    fact0 = (dz0*dy0)/xlam*sqrt(cos(angle)); 
    
    // slave thread
    // receive and process until getting j=-1
    do 
    {
      MPI_Recv(&j, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, NULL);
    
      if (j != -1)
      {
        int i;
        int k,l;
        struct complex vals[2*nz1];
        
        //printf("S[%d]: got task(%d)\n", rank, j);
                          
        //calculate_line
        for (i=0; i<nz1; i++)
        {
          struct complex val_y = {0.0, 0.0}, val_z = {0.0, 0.0};
          double xstart, ystart, zstart;
          double xend, yend, zend;
          double phase;          
          struct complex fact;

          // optical element is oriented on top
          xend = sy1[j];
          yend = -surf[j][i];
          zend = sz1[i];
          
          for (l=0; l<ny0; l++)
            for (k=0; k<nz0; k++)
            {
              struct complex y = ey0[l][k];
              struct complex z = ez0[l][k];                                     
              double dist1;
              
              
              xstart = -dist*sin(angle)-sy0[l]*cos(angle);
              ystart = -dist*cos(angle)+sy0[l]*sin(angle);
              zstart = sz0[k];
              
              dist1 = sqrt((xstart-xend)*(xstart-xend) + (ystart-yend)*(ystart-yend) + 
                           (zstart-zend)*(zstart-zend)) - fabs(dist);
            
                               
              if (dist > 0)
                phase = dist1*cc;
              else
                phase = -dist1*cc;
         
              fact.re = fact0*cos(phase)/(dist+dist1);
              fact.im = fact0*sin(phase)/(dist+dist1);
                  
              // y-polarized
              val_y.re += y.re*fact.re-y.im*fact.im;
              val_y.im += y.im*fact.re+y.re*fact.im;
              
              // z-polarized
              val_z.re += z.re*fact.re-z.im*fact.im;
              val_z.im += z.im*fact.re+z.re*fact.im;
            }
 
            vals[i] = val_y;
            vals[i+nz1] = val_z;
          }
                            
        //printf("S[%d]: [%d] = (%.2f,%.2f)\n", rank, 0, vals[0].re*1000, vals[0].im*1000);
        MPI_Send(vals, nz1*2*2, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD);

        //printf("S[%d]: sent result for task(%d)\n", rank, j);
      }
      else
        printf("S[%d]: got exit signal\n", rank);        
    } while(j != -1);
    
      printf("S[%d]: done\n", rank);   
}

/************************************************************************
 receive tasks from Master thread and send result (a line) back to Master
 mode 2: free space propagation from optical element to image plane
*************************************************************************/
void slave_propagate_2(double angle)
{
  int i, tag, src;
  int j;
  double fact0;
  
  double dist = dista;
  
  fact0 = (dz0*dy0)/xlam*sqrt(cos(angle)); 
  
  // slave thread
  // receive and process until getting j=-1
  do 
  {
    MPI_Recv(&j, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, NULL);
    
    if (j != -1)
    {
      int i;
      int k,l;
      struct complex vals[2*nz1];
        
      //printf("S[%d]: got task(%d)\n", rank, j);
        
//printf("sz0[0], = %.2f, %.2f\n", sz0[0], sy0[j]);
      
        //calculate_line
        for (i=0; i<nz1; i++)
        {
          struct complex val_y = {0.0, 0.0}, val_z = {0.0, 0.0};
          double xstart, ystart, zstart;
          double xend, yend, zend;
          double phase;          
          struct complex fact;

          // optical element is oriented on top          
          for (l=0; l<ny0; l++)
            for (k=0; k<nz0; k++)
            {
              struct complex y = ey0[l][k];
              struct complex z = ez0[l][k];                                     
              double dist1;
              
              xstart = sy0[l];
              ystart = -surf[l][k];
              zstart = sz0[k];          
              
              xend = dist*sin(angle)+sy1[j]*cos(angle);
              yend = -dist*cos(angle)+sy1[j]*sin(angle);
              zend = sz1[i];
              
              dist1 = sqrt((xstart-xend)*(xstart-xend) + (ystart-yend)*(ystart-yend) + 
                           (zstart-zend)*(zstart-zend)) - fabs(dist);
                                         
              if (dist > 0)
                phase = dist1*cc;
              else
                phase = -dist1*cc;
         
              fact.re = fact0*cos(phase)/(dist+dist1);
              fact.im = fact0*sin(phase)/(dist+dist1);
                  
              // y-polarized
              val_y.re += y.re*fact.re-y.im*fact.im;
              val_y.im += y.im*fact.re+y.re*fact.im;
              
              // z-polarized
              val_z.re += z.re*fact.re-z.im*fact.im;
              val_z.im += z.im*fact.re+z.re*fact.im;
            }
 
            vals[i] = val_y;
            vals[i+nz1] = val_z;
          }
                            
        //printf("S[%d]: [%d] = (%.2f,%.2f)\n", rank, 0, vals[0].re*1000, vals[0].im*1000);
        MPI_Send(vals, nz1*2*2, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD);

        //printf("S[%d]: sent result for task(%d)\n", rank, j);
      }
      else
        printf("S[%d]: got exit signal\n", rank);        
    } while(j != -1);
    
      printf("S[%d]: done\n", rank);   
}
