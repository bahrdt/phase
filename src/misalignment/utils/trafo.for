c$$$ File      : /afs/psi.ch/user/b/bahrdt/phase/utils/trafo.for
c$$$ Date      : <28 Oct 03 13:47:56 bahrdt> 
c$$$ Time-stamp: <06 Feb 04 14:53:25 flechsig> 
c$$$ Author    : Johannes Bahrdt, bahrdt@bessy.de
c$$$
c$$$ $Source$ 
c$$$ $Date$
c$$$ $Revision$ 
c$$$ $Author$ 

C Datei: USERDISK_3:[FLECHSIG.PHAS]TRAFO.FOR
C Datum: 14.MAY.1996
C Stand: 23-MAY-1996
C Autor: FLECHSIG, BESSY Berlin
c********************************************************************
c Koordinatentransformationen zu align.kumac
c********************************************************************
	subroutine trafo
        dimension u(3)
        vector pa,v

	write(*,*)'a',v(1),v(2),v(3)
c verschiebung
	v(1)=v(1)+pa(1)
	v(2)=v(2)+pa(2)
        v(3)=v(3)+pa(3) 
        
	write(*,*)'b',v(1),v(2),v(3)

       	ca=pa(4)
        cb=pa(5)
        cg=pa(6) 
        sa=pa(7)
        sb=pa(8)
        sg=pa(9) 

c produkt der drei Drehmatritzen

        u(1)=cb*cg*v(1)+
     &       (cg*sb*sa-sg*ca)*v(2)+
     &       (cg*sb*ca+sg*sa)*v(3)
	u(2)=sg*cb*v(1)+
     &       (sg*sb*sa+cg*ca)*v(2)+
     &       (sg*sb*ca-cg*sa)*v(3) 
        u(3)=-sb*v(1)+
     &       cb*sa*v(2)+
     &       ca*cb*v(3) 

        v(1)=u(1) 
        v(2)=u(2) 
        v(3)=u(3) 
	write(*,*)'c',v(1),v(2),v(3)
c 8888	return
	end
