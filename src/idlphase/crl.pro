;; -*-idlwave-*-
;  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseidl/crl.pro
;  Date      : <11 Jul 13 08:23:00 flechsig> 
;  Time-stamp: <16 Jul 13 10:25:40 flechsig> 
;  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

;  $Source$ 
;  $Date$
;  $Revision$ 
;  $Author$ 



pro crl, acomp=acomp, bcomp=bcomp, crlcomp=crlcomp, crlamp=crlamp, crlphase=crlphase, $
         radius=radius,  apfac=apfac, thickness=thickness, wavelength=wavelength,$
         y_vec=y_vec, z_vec=z_vec
;+
; NAME:
;   crl
;
;
; PURPOSE:
;   calculate the electric field after a parabolic compound refractive
;   (Be) lense, (thin lens approximation), units (m) and (rad)
;
;
; CATEGORY:
;   phase_calc
;
;
; CALLING SEQUENCE:
;
;
;
; INPUTS:
;   see keyword parameters
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;   acomp:      input field, idl complex array, if given parameters
;   bcomp:      output field, idl complex array
;   crlcomp:    Propagator of CRL, idl complex array
;   apfac:      aperture factor, max. ap.= apfac* radius, default= 1.0
;   crlamp:     crl amplitude factor
;   crlphase:   crl phase factor
;   radius:     the lens radius in m
;   thickness:  the thickness of the lens on axis in m
;   wavelength: the wavelength in m
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
;   material properties hard coded - only Be so far
;
;
; PROCEDURE:
;   
;
;
; EXAMPLE:
;   crl, areal=zreal, aimag=zimag, breal=z1real, bimag=z1imag, y_vec=y_vec, z_vec=z_vec
;
;
; MODIFICATION HISTORY:
;    11.7.13 UF
;-

;;; UF I do not use the complex numbers functionality in idl
;;; UF I follow the the reference follath:2013f

u1= 'usage: crl, areal=areal, aimag=aimag, [apfac=apfac,] [breal=breal,] [bimag=bimag,] [bamp=bamp,] [bphase=bphase,] [crlamp=crlamp,]'
u2= ' [crlphase=crlphase,] [radius=radius,] [thickness=thickness,] [wavelength=wavelength,] y_vec=y_vec, z_vec=z_vec'
usage= u1+u2

print, 'crl called'

if n_elements(apfac)      eq 0 then apfac     = 1.0    ;; aperture factor
if n_elements(radius)     eq 0 then radius    = 5e-4   ;; default radius    0.5 mm
if n_elements(thickness)  eq 0 then thickness = 2e-5   ;; default thickness 20 mum
if n_elements(wavelength) eq 0 then wavelength= 1e-10  ;; default 12.4 keV


if n_elements(z_vec) eq 0 then print, usage 
if n_elements(y_vec) eq 0 then print, usage 
if n_elements(acomp) eq 0 then print, usage


print, 'crl start calculation'

;; optical constants of Be - can be extended to other materials
rene        = 1.39e15   ;; 1/m^2
mu3kev      = 39.1e2    ;; 1/m
mu12p4kev   = 0.4e2     ;; 1/m
delta3kev   = 3.8e-5    ;;
delta12p4kev= 2.21e-6   ;;

;; interpolate mu and delta - should be improved
kev  = 1e-3* 1240e-9/wavelength     ;; photon energy in keV
mu   = mu3kev+    ((mu12p4kev- mu3kev)/(12.4- 3.0))       * (kev- 3.0)
delta= delta3kev+ ((delta12p4kev- delta3kev)/(12.4- 3.0)) * (kev- 3.0)
if mu    lt 0.0 then mu= 0.0        ;; avoid overflow
if delta lt 0.0 then delta= 0.0     ;; avoid overflow

mu   =mu12p4kev         ;; hard for 1 A
delta=delta12p4kev


maxr= apfac*radius       ;; define a maximum radius

print,'photon energy=',kev,', mu=', mu, ', delta=',delta,', aperture=', 2.0*maxr 

nz= n_elements(z_vec)
ny= n_elements(y_vec)

;; determine lens-propagator for the crl

crlcomp = dcomplexarr(nz, ny) ;; make a complex array
crlamp  = dblarr(nz, ny)      ;; make real array for amplitude
crlphase= dblarr(nz, ny)      ;; make real array for phase

for i=0, nz-1 do begin
    for j=0, ny-1 do begin

        rr= sqrt(z_vec[i]^2 + y_vec[j]^2)           ;; the radial distance 

        if rr lt maxr then begin                    ;; inside the aperture
            f0= exp(-mu*thickness/2.0)              ;; absorption  in the central part of the lens 
            f1= exp   (-0.5*mu        *rr^2/radius) ;; absorption  of the curved  part of the lens, 
            f2= (-1.0)*rene*wavelength*rr^2/radius  ;; phase shift in the curved  part of the lens
        endif else begin
            f4= 0.0   
            f3= 0.0
            f2= 0.0
        endelse

        ;; print,'f0=',f0,' f1=', f1, ' f2', f2
        crlcomp[i,j] = complex(cos(f2), sin(f2),/double)
       crlcomp[i,j] = crlcomp[i,j]* f0 * f1      

    endfor
endfor

;; calculate amplitude and phase of the input field and output field

bcomp = acomp * crlcomp

;; calculate  phase and ampliude of crl-propagator 

crlamp   = abs(crlcomp)
crlphase=atan(crlcomp,/phase)

print,'crl end'
return
end
;; end
