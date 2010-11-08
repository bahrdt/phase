c---------------------------------------------------------------
	subroutine get_partial_derivatives(dfdw,dfdl,
     &             d2fdw2,d2fdwdl,d2fdl2,d3fdw3,iord)
c---------------------------------------------------------------

	implicit real*8(a-h,o-z)

	dimension dfdw(0:7,0:7,0:7,0:7,0:7,0:7),
     &    	  dfdl(0:7,0:7,0:7,0:7,0:7,0:7),
     &		  d2fdw2(0:7,0:7,0:7,0:7,0:7,0:7),
     &		  d2fdwdl(0:7,0:7,0:7,0:7,0:7,0:7),
     &		  d3fdw3(0:7,0:7,0:7,0:7,0:7,0:7),
     &		  d2fdl2(0:7,0:7,0:7,0:7,0:7,0:7)

	do i=0,iord
	do j=0,iord-i
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	do m=0,iord-i-j-k-l
	do n=0,iord-i-j-k-l-m
	  d2fdw2(i,j,k,l,m,n)=0.d0
	  d3fdw3(i,j,k,l,m,n)=0.d0
	  d2fdwdl(i,j,k,l,m,n)=0.d0
	  d2fdl2(i,j,k,l,m,n)=0.d0
	enddo
	enddo
	enddo
	enddo
	enddo
	enddo

	do i=0,iord-1
	do j=0,iord-i
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	do m=0,iord-i-j-k-l
	do n=0,iord-i-j-k-l-m
	  d2fdw2(i,j,k,l,m,n)=dflotj(i+1)*dfdw(i+1,j,k,l,m,n)
	enddo
	enddo
	enddo
	enddo
	enddo
	enddo

	do i=0,iord
	do j=0,iord-i-1
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	do m=0,iord-i-j-k-l
	do n=0,iord-i-j-k-l-m
	  d2fdwdl(i,j,k,l,m,n)=dflotj(j+1)*dfdw(i,j+1,k,l,m,n)
	enddo
	enddo
	enddo
	enddo
	enddo
	enddo

	do i=0,iord
	do j=0,iord-i-1
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	do m=0,iord-i-j-k-l
	do n=0,iord-i-j-k-l-m
	  d2fdl2(i,j,k,l,m,n)=dflotj(j+1)*dfdl(i,j+1,k,l,m,n)
	enddo
	enddo
	enddo
	enddo
	enddo
	enddo

	do i=0,iord-2
	do j=0,iord-i
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	do m=0,iord-i-j-k-l
	do n=0,iord-i-j-k-l-m
	  d3fdw3(i,j,k,l,m,n)=dflotj(i+1)*dflotj(i+2)*
     &	    dfdw(i+2,j,k,l,m,n)
	enddo
	enddo
	enddo
	enddo
	enddo
	enddo

	return
	end

c--------------------------------------------------------
	subroutine get_dydz(a,g,eq27,eq28,iord)
c--------------------------------------------------------
c
c	i: y
c	j: z
c	k: dy
c	l: dz
c	m: w
c	n: l
c
c--------------------------------------------------------

	implicit real*8(a-h,o-z)

	structure/geometryst/
	  real*8 sina,cosa,sinb,cosb,
     &    	 r,rp,xdens(0:4),xlam
          integer idefl
	end structure
	record /geometryst/ g

	dimension a(0:8,0:8)

	dimension eq27(0:7,0:7,0:7,0:7,0:7,0:7)
	dimension eq27n(0:7,0:7,0:7,0:7,0:7,0:7)
	dimension eq27dn(0:7,0:7,0:7,0:7,0:7,0:7)
	dimension eq27dni(0:7,0:7,0:7,0:7,0:7,0:7)
	dimension eq28(0:7,0:7,0:7,0:7,0:7,0:7)
	dimension eq28n(0:7,0:7,0:7,0:7,0:7,0:7)
	dimension eq28dn(0:7,0:7,0:7,0:7,0:7,0:7)
	dimension eq28dni(0:7,0:7,0:7,0:7,0:7,0:7)

	do i=0,iord
	do j=0,iord-i
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	do m=0,iord-i-j-k-l
	do n=0,iord-i-j-k-l-m
	  eq27n(i,j,k,l,m,n)=0.d0
	  eq27dn(i,j,k,l,m,n)=0.d0
	  eq28n(i,j,k,l,m,n)=0.d0
	  eq28dn(i,j,k,l,m,n)=0.d0
	enddo
	enddo
	enddo
	enddo
	enddo
	enddo

c------- eq27
c------- eq27 nominator
	do m=0,iord
	do n=0,iord-m
	  eq27n(0,0,0,0,m,n)=g.sina*a(m,n)
	enddo
	enddo

	eq27n(0,0,0,0,1,0)=eq27n(0,0,0,0,1,0)-g.cosa
	eq27n(1,0,0,0,0,0)=eq27n(1,0,0,0,0,0)-1.d0
	
c------- eq27 denominator
	do m=0,iord
	do n=0,iord-m
	  eq27dn(0,0,0,0,m,n)=-g.cosa*a(m,n)
	enddo
	enddo

	eq27dn(0,0,0,0,0,0)=eq27dn(0,0,0,0,0,0)+g.r
	eq27dn(0,0,0,0,1,0)=eq27dn(0,0,0,0,1,0)-g.sina
	
c-------- eq27
	call Tay_inv_6(eq27dn,eq27dni,iord)
	call Tay_mult_6(eq27n,eq27dni,eq27,iord)

c------- eq28
c------- eq28 nominator

	eq28n(0,0,0,0,0,1)=eq28n(0,0,0,0,0,1)+1.d0
	eq28n(0,1,0,0,0,0)=eq28n(0,1,0,0,0,0)-1.d0
	
c------- eq28 denominator
	do m=0,iord
	do n=0,iord-m
	  eq28dn(0,0,0,0,m,n)=-g.cosa*a(m,n)
	enddo
	enddo

	eq28dn(0,0,0,0,0,0)=eq28dn(0,0,0,0,0,0)+g.r
	eq28dn(0,0,0,0,1,0)=eq28dn(0,0,0,0,1,0)-g.sina

c-------- eq28
	call Tay_inv_6(eq28dn,eq28dni,iord)
	call Tay_mult_6(eq28n,eq28dni,eq28,iord)

	return
	end

c--------------------------------------------------------
	subroutine get_dypdzp(a1,g,wca,xlca,
     &      ypca1,zpca1,eq33,eq34,iord)
c--------------------------------------------------------
c
c	i: y
c	j: z
c	k: dy
c	l: dz
c	m: w
c	n: l
c
c--------------------------------------------------------

	implicit real*8(a-h,o-z)

	structure/geometryst/
	  real*8 sina,cosa,sinb,cosb,
     &    	 r,rp,xdens(0:4),xlam
          integer idefl
	end structure
	record /geometryst/ g

	dimension a1(0:7,0:7,0:7,0:7)

	dimension eq33(0:7,0:7,0:7,0:7)
	dimension eq33n(0:7,0:7,0:7,0:7)
	dimension eq33dn(0:7,0:7,0:7,0:7)
	dimension eq33dni(0:7,0:7,0:7,0:7)
	dimension eq34(0:7,0:7,0:7,0:7)
	dimension eq34n(0:7,0:7,0:7,0:7)
	dimension eq34dn(0:7,0:7,0:7,0:7)
	dimension eq34dni(0:7,0:7,0:7,0:7)

	dimension wca(0:7,0:7,0:7,0:7),
     &		  xlca(0:7,0:7,0:7,0:7),
     &            ypca1(0:7,0:7,0:7,0:7),
     &            zpca1(0:7,0:7,0:7,0:7)

c------------------ replace variables
c
c	0)	wca(y,z,dy,dz) and xlca(y,z,dy,dz) are known
c
c	1)	replace w and l in u getting
c		a1(y,z,dy,dz)
	call replace_wl_in_u(a,wca,xlca,a1,iord)
c
c	2) 	then, evaluate the quotient getting dyp and dzp
c
c-----------------------------------------------------------------
	
	do i=0,iord
	do j=0,iord-i
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	  eq33n(i,j,k,l)=0.d0
	  eq33dn(i,j,k,l)=0.d0
	  eq34n(i,j,k,l)=0.d0
	  eq34dn(i,j,k,l)=0.d0
	enddo
	enddo
	enddo
	enddo

c------- eq33
c------- eq33 nominator
	do i=0,iord
	do j=0,iord-i
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	  eq33n(i,j,k,l)=a1(i,j,k,l)*g.sinb
     &         -wca(i,j,k,l)*g.cosb+ypca1(i,j,k,l)
	enddo
	enddo
	enddo
	enddo

c------- eq33 denominator
	do i=0,iord
	do j=0,iord-i
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	  eq33dn(i,j,k,l)=-a1(i,j,k,l)*g.cosb
     &         -wca(i,j,k,l)*g.sinb
	enddo
	enddo
	enddo
	enddo

	eq33dn(0,0,0,0)=eq33dn(0,0,0,0)+g.rp
	
c-------- eq33
	call Tay_inv_4(eq33dn,eq33dni,iord)
	call Tay_mult_4(eq33n,eq33dni,eq33,iord)

c------- eq34
c------- eq34 nominator
	do i=0,iord
	do j=0,iord-i
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	  eq34n(i,j,k,l)=xlca(i,j,k,l)-zpca1(i,j,k,l)
	enddo
	enddo
	enddo
	enddo
	
c------- eq34 denominator
	do i=0,iord
	do j=0,iord-i
	do k=0,iord-i-j
	do l=0,iord-i-j-k
	  eq34dn(i,j,k,l)=-wca(i,j,k,l)*g.sinb
     &                    -a1(i,j,k,l)*g.cosb
	enddo
	enddo
	enddo
	enddo

	eq34dn(0,0,0,0)=eq34dn(0,0,0,0)+g.rp
	
c-------- eq34
	call Tay_inv_4(eq34dn,eq34dni,iord)
	call Tay_mult_4(eq34n,eq34dni,eq34,iord)

	return
	end

