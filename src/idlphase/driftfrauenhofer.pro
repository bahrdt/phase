;; -*-idlwave-*-
;  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseidl/drift.pro
;  Date      : <11 Jul 13 08:23:00 flechsig> 
;  Time-stamp: <18 Jul 13 17:18:21 flechsig> 
;  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

;  $Source$ 
;  $Date$
;  $Revision$ 
;  $Author$ 



pro driftfrauenhofer, acomp=acomp, areal=areal, aimag=aimag, bcomp=bcomp, breal=breal, bimag=bimag, $
           bamp=bamp, bphase=bphase, drift=drift, plot=plot, $
           wavelength=wavelength, y_vec=y_vec, z_vec=z_vec, u=u, v=v
;+
; NAME:
;   driftfrauenhofer
;
;
; PURPOSE:
;   calculate the electric field after some distance in vacuum
;   Frauenhofer approximation
;
;
; CATEGORY:
;   phase_calc
;
;
; CALLING SEQUENCE:
;   drift, acomp=acomp, z_vec=z_vec, y_vec=y_vec
;
; INPUTS:
;   
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;   acomp:      input field, idl complex array, if given parameters
;               areal, aimag are ignored
;   areal:      input field, real part (required)
;   aimag:      input field, imag. part (required)
;   bcomp:      output field, idl complex array
;   bamp:       output field, amplitude
;   bphase:     output field, phase
;   breal:      output field, real part
;   bimag:      output field, imag part
;   drift:      drift distance in m
;   plot:       make contour plot of amplitude
;   wavelength: the wavelength in m
;   u:          the horizontal output vector
;   v:          the vertical output vector
;   y_vec:      vertical input vector (required) in m
;   z_vec:      horizontal input vector (required) in m
;
; OUTPUTS:
;   see keyword parameters
;
;
; OPTIONAL OUTPUTS:
;
;
;
; COMMON BLOCKS:
;   no
;
;
; SIDE EFFECTS:
;
;
;
; RESTRICTIONS:
;
;
; PROCEDURE:
;   
;
;
; EXAMPLE:
;   drift, areal=zreal, aimag=zimag, breal=z1real, bimag=z1imag, y_vec=y_vec, z_vec=z_vec
;
;
; MODIFICATION HISTORY:
;    11.7.13 UF
;-

;;; UF I follow the the reference follath:2013f

u1= 'usage: drift, [acomp=acomp,][areal=areal,][aimag=aimag,][apfac=apfac,][breal=breal,][bimag=bimag,][bamp=bamp,][bphase=bphase,]'
u2= '[wavelength=wavelength,] y_vec=y_vec, z_vec=z_vec'
usage= u1+u2

print, 'driftfresnel called'

if n_elements(drift)      eq 0 then drift     = 100.   ;; default thickness 20 mum
if n_elements(wavelength) eq 0 then wavelength= 1e-10  ;; default 12.4 keV
if n_elements(z_vec) eq 0 then begin 
    print, usage & return 
endif
if n_elements(y_vec) eq 0 then begin 
    print, usage & return 
endif
if n_elements(acomp) eq 0 and (n_elements(areal) eq 0 or n_elements(aimag) eq 0) then begin 
    print, usage & return 
endif
if n_elements(acomp) eq 0 then acomp= complex(areal, aimag, /double)

print, 'drift start calculation'

nz= n_elements(z_vec)
ny= n_elements(y_vec)
zz= z_vec[nz-1]- z_vec[0]                                      ;; total length
yy= y_vec[ny-1]- y_vec[0]                                      ;; total length

;; determine factors for amplitude and phase for the drift
scale   = dcomplexarr(nz, ny) ;; make a complex array
k       = 2* !dpi/wavelength

field0= acomp                                                 ;; the inner part of the fft

field1= fft(field0, -1, /center, /double)                      ;; forward 2d fft, centered output

u0= dindgen(nz)/nz - 0.5                                       ;; define the vectors in the image plane
v0= dindgen(ny)/ny - 0.5
uscale= (drift*wavelength)/zz * nz
vscale= (drift*wavelength)/yy * ny
u= u0*uscale[0]
v= v0*vscale[0]

help, u, v, zz, nz, uscale, u0

;help,ny,nz
;print,ny,nz

for i=0, nz-1 do begin
    for j=0, ny-1 do begin
        phase= k * (u[i]^2 + v[j]^2) / (2.0*drift)             
        scale[i,j]= complex(cos(phase), sin(phase), /double)   
    endfor
endfor

scale1=complex(cos(k*drift), sin(k*drift), /double)
scale2=complex(0., (wavelength*drift), /double)

help, scale1, scale2, scale, field1

bcomp= zz * yy * field1 * scale * scale1[0]/ scale2[0]

;; calculate real and imag description
breal= real_part(bcomp)
bimag= imaginary(bcomp)
bamp  = abs(bcomp)
bphase= atan(bcomp,/phase)

help, bamp, u, v
if n_elements(plot) ne 0 then mycontour, bamp,u*1e3,v*1e3, xtitle='z (mm)', ytitle='y (mm)', title='drift'

print,'drift end'
return
end
;; end
