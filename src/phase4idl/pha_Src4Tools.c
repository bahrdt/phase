

// pha_Src4Tools.c
//
// (c) 2008 : Torsten.Leitner@email.de
//

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <complex.h>
//#include <stdarg.h> 
//#include <string.h>

#include "Constants.h"

#include <phase_struct.h>

#include "pha4idl_prototypes.h"

#include <idl_export.h>


// /* *** Fortran-Access ***  
// aus irgendnem grund den keiner versteht, klappt dies nur, wenn idl ne 
// c-routine "phaModGrid" aufruft, die dann direkt "phaModGrid_cwrap" aufruft...
//
int phaModGrid_cwrap (struct source4 *beam, int *nz2in, int *ny2in)
{ 
// /*

  int MaxDim = 256;
  double
   zezre[MaxDim][MaxDim],zezim[MaxDim][MaxDim],zeyre[MaxDim][MaxDim],zeyim[MaxDim][MaxDim];
  
  double zmin,zmax,ymin,ymax;
  
  int iz,iy,ny1,ny2,nz1,nz2;
  
  nz2=*nz2in;
  ny2=*ny2in;
  
  // Aktuelles Grid aus Struktur lesen
  pha_c_extract_src4_grid(beam,nz1,zmin,zmax,ny1,ymin,ymax);
  
  
  if(nz1>MaxDim) return 1;
  if(ny1>MaxDim) return 1;
  if(nz2>MaxDim) return 1;
  if(ny2>MaxDim) return 1;

  
   
  // FElder kopieren oder feldpointer kopieren ???   TESTEN !!!
  for(iz=0;iz<nz1;iz++) {
     for(iy=0;iy<ny1;iy++) {
        zezre[iz][iy] = beam->zezre[iz][iy]; 
//printf("%i %i %g \n",iz,iy,zezre[iz][iy]);
	  zezim[iz][iy] = beam->zezim[iz][iy];
	  zeyre[iz][iy] = beam->zeyre[iz][iy];
	  zeyim[iz][iy] = beam->zeyim[iz][iy];        
     }
  }
 
// /*  
  // Felder auf neuem Grid interpolieren
  extern void pha_src4_modgrid_structfree_(); // Declare the Fortran Routine 
// /*  // Call the Fortran Routine 
  pha_src4_modgrid_structfree_(MaxDim
                    ,zezre,zezim,zeyre,zeyim
                    ,&nz1,&nz2 ,&zmin,&zmax
                    ,&ny1,&ny2 ,&ymin,&ymax) ;
// */
// /*
  // Neues Grid in Struktur schreiben
  pha_c_define_src4_grid(beam, nz2, zmin, zmax, ny2, ymin, ymax);

  // Neue Felder in Struktur schreiben
  for(iz=0;iz<nz2;iz++) {
     for(iy=0;iy<ny2;iy++) {
        beam->zezre[iz][iy] = zezre[iz][iy];
	  beam->zezim[iz][iy] = zezim[iz][iy];
	  beam->zeyre[iz][iy] = zeyre[iz][iy];
	  beam->zeyim[iz][iy] = zeyim[iz][iy];        
     }
  }
// */  
  return (0);
}
// */







int pha_c_extract_src4_grid(struct source4 *src4,
                            int nz, double zmin, double zmax,
				    int ny, double ymin, double ymax)
//c% Routine liest Grid-Daten aus source4-Struktur aus
{	
//c  Definiere Referenzen explizit, um flexibler zu bleiben ...
//c
//c Lese aus Referenzsturkturen
	  nz = src4->ieyrex;
	zmin = src4->xeyremin;
	zmax = src4->xeyremax;
	  ny = src4->ieyrey;
	ymin = src4->yeyremin;
	ymax = src4->yeyremax;
	
	return 0;
} //	end !extract_src4_grid
//cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77



int  pha_c_define_src4_grid(struct source4 *src4,
                            int nz, double zmin, double zmax,
				    int ny, double ymin, double ymax)
//c% Routine definiert die in src4-Structs redundanten Grid-Parameter
{
//c      
      double dz=(zmax-zmin)/(nz-1);
      double dy=(ymax-ymin)/(ny-1);

//c alle nz
      src4->ieyrex=nz;
      src4->ieyimx=nz;
      src4->iezrex=nz;
      src4->iezimx=nz;
//c alle ny
      src4->ieyrey=ny;
      src4->ieyimy=ny;
      src4->iezrey=ny;
      src4->iezimy=ny;
//c alle dz
      src4->dxeyre=dz;
      src4->dxeyim=dz;
      src4->dxezre=dz;
      src4->dxezim=dz;
//c alle dy         
      src4->dyeyre=dy;
      src4->dyeyim=dy;
      src4->dyezre=dy;
      src4->dyezim=dy;
//c alle zmin
      src4->xeyremin=zmin;
      src4->xeyimmin=zmin;
      src4->xezremin=zmin;
      src4->xezimmin=zmin;
//c alle ymin
      src4->yeyremin=ymin;
      src4->yeyimmin=ymin;
      src4->yezremin=ymin;
      src4->yezimmin=ymin;
//c alle zmax
      src4->xeyremax=zmax;
      src4->xeyimmax=zmax;
      src4->xezremax=zmax;
      src4->xezimmax=zmax;
//c alle ymax
      src4->yeyremax=ymax;
      src4->yeyimmax=ymax;
      src4->yezremax=ymax;
      src4->yezimmax=ymax;

      return 0;
} //      end !define_src4_grid

int pha_c_adjust_src4_grid(struct source4 *src4)
{
//c% Routine gleicht die in src4-Structs redundanten Grid-Parameter
//c% anhand bestimmter Referenzvariablen aneinander an.

//c  Definiere Referenzen explizit, um flexibler zu bleiben ...
//c  dx,dy werden berechnet, um sicherzugehen, das die Daten konsistent sind.
//c Lese aus Referenzsturkturen
//c Es werden immer alle Elemente neu geschrieben, da man dann die
//c Referenz-Elemente nur in Subroutine "extract_src4_grid" definieren muss

	double zmin,zmax,ymin,ymax;
	int    nz,ny;

	pha_c_extract_src4_grid(src4,nz,zmin,zmax,ny,ymin,ymax);

	pha_c_define_src4_grid(src4,nz,zmin,zmax,ny,ymin,ymax);

	return 0;
}	//end !adjust_src4_grid
//cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77


/*


	
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77
	subroutine pha_src4_cut(src4, nzmin,nzmax,nymin,nymax)
	
	implicit none
	include 'myphase_struct.for'

#ifdef ABSOFT
      record /source4/ src4
#else      
      type(source4)::src4 
#endif	

	integer nz1,ny1,nzmax,nzmin,nymax,nymin,nz2,ny2
	real*8  temp(1024,1024),zmin,zmax,ymin,ymax,dz1,dy1

	if ((nzmax.gt.nzmin).and.(nymax.gt.nymin)) then
	! Eingangsbedingung !
	! Nur falls obere Grenzen goesser als untere wird gestartet ... !
	
	write(*,*)'Cutting grid ...'
	
	call pha_extract_src4_grid(src4,nz1,zmin,zmax,ny1,ymin,ymax)

	if (nzmax.gt.nz1) nzmax=nz1
	if (nzmin.lt.1)   nzmin=1
	if (nymax.gt.ny1) nymax=ny1
	if (nymin.lt.1) nymin=1
	
	dz1=(zmax-zmin)/(nz1-1)
      dy1=(ymax-ymin)/(ny1-1)
      
      zmin=zmin+(nzmin-1)*dz1
      zmax=zmax-(nz1-nzmax)*dz1
      
      ymin=ymin+(nymin-1)*dy1
      ymax=ymax-(ny1-nymax)*dy1
	
	nz2=nzmax-nzmin+1
	ny2=nymax-nymin+1
    
	call pha_define_src4_grid(src4,nz2,zmin,zmax,ny2,ymin,ymax  )
#ifdef ABSOFT		
#else
	temp(1:nz2,1:ny2)   =  src4.zeyre(nzmin:nzmax,nymin:nymax)
	src4.zeyre(:,:)     =  0
	src4.zeyre(1:nz2,1:ny2)=temp(1:nz2,1:ny2)
	
	temp(1:nz2,1:ny2)   =  src4.zeyim(nzmin:nzmax,nymin:nymax)
	src4.zeyim(:,:)     =  0
	src4.zeyim(1:nz2,1:ny2)=temp(1:nz2,1:ny2)
	
	temp(1:nz2,1:ny2)   =  src4.zezre(nzmin:nzmax,nymin:nymax)
	src4.zezre(:,:)     =  0
	src4.zezre(1:nz2,1:ny2)=temp(1:nz2,1:ny2)
	
	temp(1:nz2,1:ny2)   =  src4.zezim(nzmin:nzmax,nymin:nymax)
	src4.zezim(:,:)     =  0
	src4.zezim(1:nz2,1:ny2)=temp(1:nz2,1:ny2)
#endif     
	endif ! Eingangsbedingung !
	return
	end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77
	subroutine pha_src4_addzeros(src4,nz2,ny2)
	
	implicit none
	include 'myphase_struct.for'
#ifdef ABSOFT
      record /source4/ src4
#else      
      type(source4)::src4 
#endif

	integer nz2,ny2,nz1,ny1,nz_delta,ny_delta
	real*8  temp(1024,1024),zmin,zmax,ymin,ymax,dz1,dy1
	
	write(*,*)'Adding zeros ...'
	
	call pha_extract_src4_grid(src4,nz1,zmin,zmax,ny1,ymin,ymax)
	
	if (nz2.lt.nz1) nz2=nz1
	if (ny2.lt.ny1) ny2=ny1
	! falls eine Grenze kleiner stuerzts ab...
	! Setze kleinere Grenze auf Urspruengliche 

	if (mod((nz2-nz1),2).eq.1) nz2=nz2-1  ! nxd=delta(nx1,nx2)=gerade
      if (mod((ny2-ny1),2).eq.1) ny2=ny2-1
	
	nz_delta=(nz2-nz1)/2    ! Halber Unterschied der Anzahl der Datenpunkte
      ny_delta=(ny2-ny1)/2    ! Immer ganzzahlig, da N_delta gerade oben 
					! erzwungen wird

	dz1=(zmax-zmin)/(nz1-1)
      dy1=(ymax-ymin)/(ny1-1)
      
      zmin=zmin-nz_delta*dz1
      zmax=zmax+nz_delta*dz1
      
      ymin=ymin-ny_delta*dy1
      ymax=ymax+ny_delta*dy1
	    
	call pha_define_src4_grid(src4,nz2,zmin,zmax,ny2,ymin,ymax)
     
c..... AddZeros.....
#ifdef ABSOFT		
#else
	temp(1:nz1,1:ny1)   =  src4.zeyre(1:nz1,1:ny1)
	src4.zeyre(:,:)     =  0
	src4.zeyre(1+nz_delta:1+nz_delta+nz1,1+ny_delta:1+ny_delta+ny1) =
     &		 temp(1:ny1,1:nz1)

      
	temp(1:nz1,1:ny1)   =  src4.zeyim(1:nz1,1:ny1)
	src4.zeyim(:,:)     =  0
	src4.zeyim(1+nz_delta:1+nz_delta+nz1,1+ny_delta:1+ny_delta+ny1) =
     &		 temp(1:ny1,1:nz1)
     
      
	temp(1:nz1,1:ny1)   =  src4.zezre(1:nz1,1:ny1)
	src4.zezre(:,:)     =  0
	src4.zezre(1+nz_delta:1+nz_delta+nz1,1+ny_delta:1+ny_delta+ny1) =
     &		 temp(1:ny1,1:nz1)
     
      
	temp(1:nz1,1:ny1)   =  src4.zezim(1:nz1,1:ny1)
	src4.zezim(:,:)     =  0
	src4.zezim(1+nz_delta:1+nz_delta+nz1,1+ny_delta:1+ny_delta+ny1) =
     &		 temp(1:ny1,1:nz1)
#endif     
	return
	end    ! pha_src4_addzero
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77
	subroutine pha_init_src4(src4)
      
	implicit none
	include 'myphase_struct.for'
#ifdef ABSOFT
      record /source4/ src4
#else      
      type(source4)::src4 
#endif
	integer i,j
c alle nz
	src4.ieyrex=0
	src4.ieyimx=0
	src4.iezrex=0
	src4.iezimx=0
c alle ny
	src4.ieyrey=0
	src4.ieyimy=0
	src4.iezrey=0
	src4.iezimy=0
c alle dz
	src4.dxeyre=0
	src4.dxeyim=0
	src4.dxezre=0
	src4.dxezim=0
c alle dy		
	src4.dyeyre=0
	src4.dyeyim=0
	src4.dyezre=0
	src4.dyezim=0
c alle zmin
	src4.xeyremin=dble(0)
	src4.xeyimmin=dble(0)
	src4.xezremin=dble(0)
	src4.xezimmin=dble(0)
c alle ymin
	src4.yeyremin=dble(0)
	src4.yeyimmin=dble(0)
	src4.yezremin=dble(0)
	src4.yezimmin=dble(0)
c alle zmax
	src4.xeyremax=dble(0)
	src4.xeyimmax=dble(0)
	src4.xezremax=dble(0)
	src4.xezimmax=dble(0)
c alle ymax
	src4.yeyremax=dble(0)
	src4.yeyimmax=dble(0)
	src4.yezremax=dble(0)
	src4.yezimmax=dble(0)
c  lambda
	src4.xlam=dble(0)
c  Setze alle E-Felder 
	do i=1,256
	  do j=1,256
	    src4.zeyre(i,j)=dble(0)
	    src4.zeyim(i,j)=dble(0)
	    src4.zezre(i,j)=dble(0)
	    src4.zezim(i,j)=dble(0)
	  enddo
	enddo    
	return
	end !init_src4
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77




cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77
	subroutine pha_src4_modgrid(src4,nz2,ny2)
     
	implicit none
	
	common/cstak/dstak
	
	include 'myphase_struct.for'
#ifdef ABSOFT
      record /source4/ src4
#else      
      type(source4)::src4 
#endif	
	integer k,nz2,ny2,nz1,ny1
	real*8  dz1,dz2,dy1,dy2,ymax,ymin,zmax,zmin
     &	 ,z1(1024),z2(1024),y1(1024),y2(1024)
     &	 ,data_in(1024),data_out(1024)
     &	 ,dstak(6144)
     
      write(*,*)'Changing number of grid-points ...'
      
	call ISTKIN(6144,4)
	
	call pha_extract_src4_grid(src4,nz1,zmin,zmax,ny1,ymin,ymax)
	
	dz1=(zmax-zmin)/(nz1-1)
      dy1=(ymax-ymin)/(ny1-1)
	do k=1,nz1
		z1(k)=dble(k-1)*dz1
	enddo
	do k=1,ny1
		y1(k)=dble(k-1)*dy1
	enddo
	
	dz2=(zmax-zmin)/(nz2-1)
      dy2=(ymax-ymin)/(ny2-1)
	
	do k=1,nz2
		z2(k)=dble(k-1)*dz2
	enddo
	do k=1,ny2
		y2(k)=dble(k-1)*dy2
	enddo


	do k=1,ny1  ! Interpoliere alle Vektoren in z-Richtung
#ifdef ABSOFT		
#else
		data_in(1:nz1) = src4.zezre(1:nz1,k)
		src4.zezre(:,k)= 0.d0
#endif
		call DCSPIN(z1,data_in,nz1,z2,data_out,nz2)
#ifdef ABSOFT		
#else
		src4.zezre(1:nz2,k)=data_out(1:nz2)
		data_in(1:nz1) = src4.zezim(1:nz1,k)
		src4.zezim(:,k)= 0.d0
#endif
		call DCSPIN(z1,data_in,nz1,z2,data_out,nz2)
#ifdef ABSOFT		
#else
		src4.zezim(1:nz2,k)=data_out(1:nz2)
		
		data_in(1:nz1) = src4.zeyre(1:nz1,k)
		src4.zeyre(:,k)= 0.d0
#endif
		call DCSPIN(z1,data_in,nz1,z2,data_out,nz2)
#ifdef ABSOFT		
#else
		src4.zeyre(1:nz2,k)=data_out(1:nz2)
		
		data_in(1:nz1) = src4.zeyim(1:nz1,k)
		src4.zeyim(:,k)= 0.d0
#endif
		call DCSPIN(z1,data_in,nz1,z2,data_out,nz2)
#ifdef ABSOFT		
#else
		src4.zeyim(1:nz2,k)=data_out(1:nz2)
#endif	
	enddo
#ifdef ABSOFT		
#else	
	data_in(:) =0.d0
	data_out(:)=0.d0
#endif	
	do k=1,nz2  ! Interpoliere alle Vektoren in y-Richtung
			! Beachte: nz1 -> nz2 bereits durchgefuehrt 
		
#ifdef ABSOFT		
#else
		data_in(1:ny1) = src4.zezre(k,1:ny1)
		src4.zezre(k,:)= 0.d0
#endif
		call DCSPIN(y1,data_in,ny1,y2,data_out,ny2)
#ifdef ABSOFT		
#else
		src4.zezre(k,1:ny2)=data_out(1:ny2)
		
		data_in(1:ny1) = src4.zezim(k,1:ny1)
		src4.zezim(k,:)= 0.d0
#endif
		call DCSPIN(y1,data_in,ny1,y2,data_out,ny2)
#ifdef ABSOFT		
#else
		src4.zezim(k,1:ny2)=data_out(1:ny2)
		
		data_in(1:ny1) = src4.zeyre(k,1:ny1)
		src4.zeyre(k,:)= 0.d0
#endif
		call DCSPIN(y1,data_in,ny1,y2,data_out,ny2)
#ifdef ABSOFT		
#else
		src4.zeyre(k,1:ny2)=data_out(1:ny2)
		
		data_in(1:ny1) = src4.zeyim(k,1:ny1)
		src4.zeyim(k,:)= 0.d0
#endif
		call DCSPIN(y1,data_in,ny1,y2,data_out,ny2)
#ifdef ABSOFT		
#else
		src4.zeyim(k,1:ny2)=data_out(1:ny2)
#endif	
	enddo
	
	call pha_define_src4_grid(src4,nz2,zmin,zmax,ny2,ymin,ymax)
      
	return
	end   !pha_src4_modgrid
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77


// */
