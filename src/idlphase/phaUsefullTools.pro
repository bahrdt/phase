; Name: UsefullTools.pro


;;
PRO WaitForEnter
;; wait for until <ENTER> is pressed
tmp=''
read,tmp,prompt='Press enter to continue ... '
END



;;
FUNCTION pha4idlByteArray2String, ba
;; Converts a bytearray (char[] in C) to an idlstring of same length
;
; a=size(x)
; -> array:  a(0)=#dim - a(1)=dim_1 - a(i)=dim_i - a(#dim)=dim_#dim 
;         - a(#dim+1)= type code - a(#dim+2)= tot.elements in all dims

sdim=size(ba)

if sdim(0) ne 1 then begin 
            print,'*** error in function: ByteArray2String ***'
            print,'Only 1D bytearrays are supported, Dimension was : ', sdim(0)
            return, '*** error in function: ByteArray2String ***'
endif else begin
    slen=sdim(1)
endelse

if sdim(2) ne 1 then begin 
            print,'*** warning from function: ByteArray2String ***'
            print,'Input argument NOT of type bytearray.'
endif


;; kill all leading whitespaces
k=0
kstart=0
while k lt slen do begin
            kstart=k
            if ba(k) ne 0 then k=slen+1
            k=k+1
endwhile

s=replicate(' ',slen)

s=string( ba(kstart:slen-1) )

return, s
END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro phaCopyFieldFiles, src, dest
;+
; NAME:
;	phaCopyFieldFiles
;
; PURPOSE:
;       Copy phase field files on hdd
;
; CATEGORY:
;	pro : pha4idl - tools
;
; CALLING SEQUENCE:
;	phaCopyFieldFiles, src, dest
;
; INPUTS:
;     	src		source prefix
;     	dest		destination prefix
;
;			phase adds the following postfixes:
;			-ezre, -ezim, -eyre, -eyim  : real and imaginary 
;				of the EM-fields with z & y polarizaiton
;
; OUTPUTS:
;
; KEYWORDS:
;	None.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; MODIFICATION HISTORY:
;      March 28, 2008, TL, added help
;
;-

; infiles nach tmpfiles kopieren
spawn,'cp -f --reply=yes '+src+'-eyrec '+dest+'-eyrec'
spawn,'cp -f --reply=yes '+src+'-eyimc '+dest+'-eyimc'
spawn,'cp -f --reply=yes '+src+'-ezrec '+dest+'-ezrec'
spawn,'cp -f --reply=yes '+src+'-ezimc '+dest+'-ezimc'

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro phaMoveFieldFiles, src, dest
;+
; NAME:
;	phaMoveFieldFiles
;
; PURPOSE:
;       Move phase field files on hdd
;
; CATEGORY:
;	pro : pha4idl - tools
;
; CALLING SEQUENCE:
;	phaMoveFieldFiles, src, dest
;
; INPUTS:
;     	src		source prefix
;     	dest		destination prefix
;
;			phase adds the following postfixes:
;			-ezre, -ezim, -eyre, -eyim  : real and imaginary 
;				of the EM-fields with z & y polarizaiton
;
; OUTPUTS:
;
; KEYWORDS:
;	None.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; MODIFICATION HISTORY:
;      March 28, 2008, TL, added help
;
;-
; tmpfiles nach outfiles kopieren
spawn,'mv -f --reply=yes '+src+'-eyrec '+dest+'-eyrec'
spawn,'mv -f --reply=yes '+src+'-eyimc '+dest+'-eyimc'
spawn,'mv -f --reply=yes '+src+'-ezrec '+dest+'-ezrec'
spawn,'mv -f --reply=yes '+src+'-ezimc '+dest+'-ezimc'
                         
                         
END                      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







function phasrc4add, beam1, beam2

; Calculates the difference of the EM-fields in 2 Beam-Structures
; Assuming that beam2 has the same Grid-Parameters as beam1

beamsum={source4}
beamsum=beam1
	
beamsum.zeyre=beam1.zeyre+beam2.zeyre
beamsum.zeyim=beam1.zeyim+beam2.zeyim
beamsum.zezre=beam1.zezre+beam2.zezre
beamsum.zezim=beam1.zezim+beam2.zezim

return, beamsum

END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function phasrc4diff, beam1, beam2

; Calculates the difference of the EM-fields in 2 Beam-Structures
; Assuming that beam2 has the same Grid-Parameters as beam1

beamdiff={source4}
beamdiff=beam1
	
beamdiff.zeyre=beam1.zeyre-beam2.zeyre
beamdiff.zeyim=beam1.zeyim-beam2.zeyim
beamdiff.zezre=beam1.zezre-beam2.zezre
beamdiff.zezim=beam1.zezim-beam2.zezim

return, beamdiff

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


pro phaLabelSrc4, beam, name

; Labels the fsource4(a-d)-Tags

;label = bytearr(80)
;label(0:strlen(name)-1 = byte(name) 

beam.fsource4a=bytarr(80)
beam.fsource4b=bytarr(80)
beam.fsource4c=bytarr(80)
beam.fsource4d=bytarr(80)

beam.fsource4a(0:strlen(name+'_a')-1) = byte(name+'_a') 
beam.fsource4b(0:strlen(name+'_b')-1) = byte(name+'_b')
beam.fsource4c(0:strlen(name+'_c')-1) = byte(name+'_c')
beam.fsource4d(0:strlen(name+'_d')-1) = byte(name+'_d')

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


