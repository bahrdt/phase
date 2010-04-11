
;
; AUTHOR :  Torsten.Leitner@email.de
;     (c) 2007/2008
;
; FILE : phaPropagation.pro
;
; PRODCEDURES :
;                 phaPropFFTfar
;                 phaPropFFTnear
;                 phaPropWFFresnelKirchhoff
;
;
; FUNCTIONS :
;
;
;
;

pro phaPropFFTfar, beam, distance
;+
; NAME:
;	phaPropFFTfar
;
; PURPOSE:
;       Propagate the fields in a pha4idl beamline structure 
;	with a farfield fourier propagator.
;
; CATEGORY:
;	pro : pha4idl - Free space propagator
;
; CALLING SEQUENCE:
;	phaPropFFTfar, beam, distance
;
; INPUTS:
;     	beam:		struct Source4 containing EM fields to propagate
;     	distance:	propagation distance [mm]
;
; OUTPUTS:
;     	beam:		initial fields are overwritten with the new values
;
;
; KEYWORDS:
;	None.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;       'libphase4idl.so' required! 
;       see also 'phainit.pro' -> '!phalib' must be defined correctly
;
; MODIFICATION HISTORY:
;      March 7, 2008, TL, added help
;
;-

lib= !phalib
func='phaPropFFTfar'

; beam is of type src4 

np=n_params()
IF np NE 2 THEN BEGIN 
   print,''
   print,'Wrong Number of Arguments in procedure:  phaPropFFTfar '
   print,'ArgCount is ',np,',    but should be     2.'
   print,'Returning to IDL-Level 0 (main) ...'
   print,''
   retall
ENDIF

distance=double(distance)


result=1
result = call_external( lib,func,$
			beam, $
			distance,  $
			/I_VALUE,/UNLOAD,/CDECL,/AUTO_GLUE,/IGNORE_EXISTING_GLUE)

;print, '***',result,'  ***'
END
;--------------------------------------------------------------------------------------------------;


pro phaPropFFTnear, beam, distance	
;+
; NAME:
;	phaPropFFTnear
;
; PURPOSE:
;       Propagate the fields in a pha4idl beamline structure 
;	with a nearfield fourier propagator.
;
; CATEGORY:
;	pro : pha4idl - Free space propagator
;
; CALLING SEQUENCE:
;	phaPropFFTnear, beam, distance	 
;
; INPUTS:
;     	beam:		struct Source4 containing EM fields to propagate
;     	distance:	propagation distance [mm]
;
; OUTPUTS:
;     	beam:		initial fields are overwritten with the new values
;
;
; KEYWORDS:
;	None.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;       'libphase4idl.so' required! 
;       see also 'phainit.pro' -> '!phalib' must be defined correctly
;
; MODIFICATION HISTORY:
;      March 7, 2008, TL, added help
;
;-

lib= !phalib
func='phaPropFFTnear'

; beam is of type src4 

np=n_params()
IF np NE 2 THEN BEGIN 
   print,''
   print,'Wrong Number of Arguments in procedure:  phaPropFFTnear '
   print,'ArgCount is ',np,',    but should be      2.'
   print,'Returning to IDL-Level 0 (main) ...'
   print,''
   retall
ENDIF

distance=double(distance)


result=1
result = call_external(lib,func,$
			beam, $
			distance,  $
			/I_VALUE,/UNLOAD,/CDECL,/AUTO_GLUE,/IGNORE_EXISTING_GLUE)

;print, '***',result,'  ***'
END
;--------------------------------------------------------------------------------------------------;

pro phaPropWFFresnelKirchhoff, beam, distance, nz2, zmin2, zmax2, ny2, ymin2, ymax2 
;+
; NAME:
;	phaPropWFFresnelKirchhoff
;
; PURPOSE:
;       Propagate the fields in a pha4idl beamline structure 
;	with the Fresnel-Kirchhoff integration method.
;
; CATEGORY:
;	pro : pha4idl - Free space propagator
;
; CALLING SEQUENCE:
;	phaPropWFFresnelKirchhoff, beam, distance, nz2, zmin2, zmax2, ny2, ymin2, ymax2 
;
; INPUTS:
;     	beam:		struct Source4 containing EM fields to propagate
;     	distance:	propagation distance [mm]
;
;	nz2:		imageplane: number of gridpoints in z-direction
;	zmin2:		imageplane: lower border in z-direction [mm]
;	zmax2:		imageplane: upper border in z-direction [mm]
;
;	ny2:		imageplane: number of gridpoints in y-direction
;	ymin2:		imageplane: lower border in y-direction [mm]
;	ymax2:		imageplane: upper border in y-direction [mm]
;
; OUTPUTS:
;     	beam:		initial fields are overwritten with the new values
;
;
; KEYWORDS:
;	None.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;       'libphase4idl.so' required! 
;       see also 'phainit.pro' -> '!phalib' must be defined correctly
;
; MODIFICATION HISTORY:
;      March 7, 2008, TL, added help
;
;-
lib= !phalib
func='phaPropWFFresnelKirchhoff'

np=n_params()
IF np NE 8 THEN BEGIN 
   print,''
   print,'Wrong Number of Arguments in procedure:  phaPropWFFresnelKirchhoff '
   print,'ArgCount is ',np,',    but should be     8.'
   print,'Returning to IDL-Level 0 (main) ...'
   print,''
   retall
ENDIF

nz2=long(nz2)
zmin2=double(zmin2)
zmax2=double(zmax2)
ny2=long(ny2)
ymin2=double(ymin2)
ymax2=double(ymax2)
distance=double(distance)

result=1
result = call_external( lib,func,$
			beam, distance, $
			nz2, zmin2, zmax2, $
			ny2, ymin2, ymax2, $
			/I_VALUE,/UNLOAD,/CDECL,/AUTO_GLUE,/IGNORE_EXISTING_GLUE)

;print, '***',result,'  ***'
END
;--------------------------------------------------------------------------------------------------;


;--------------------------------------------------------------------------------------------------;
pro phaPropWFFKoe, beam, dist, dista, angle, mode, surffilename, nz2, zmin2, zmax2, ny2, ymin2, ymax2 
;+
; NAME:
;	phaPropWFFKoe
;
; PURPOSE:
;       Propagate the fields in a pha4idl beamline structure 
;	with the Fresnel-Kirchhoff integration method with optical element.
;
; CATEGORY:
;	pro : pha4idl - Free space propagator
;
; CALLING SEQUENCE:
;	phaPropWFFKoe, beam, dist, dista, angle, mode, surffilename, nz2, zmin2, zmax2, ny2, ymin2, ymax2  
;
; INPUTS:
; beam:		struct Source4 containing EM fields to propagate
; dist:	  propagation distance from source to optical element [mm]
; dista:  propagation distance from optical element to image plane [mm]
; angle:	angle to surface normal [deg]
; mode:	  propagation mode: 1  = propagation from source to optical element
;                           2  = propagation from optical element to image
;	                          3  = propagation from sourc to image via application of
;	                               two steps: 1) from source to oe, 2) from oe to image
;	                         10 = no optical element
;
; surffilename: filename of the optical element surface
;
;	nz2:		imageplane: number of gridpoints in z-direction
;	zmin2:		imageplane: lower border in z-direction [mm]
;	zmax2:		imageplane: upper border in z-direction [mm]
;
;	ny2:		imageplane: number of gridpoints in y-direction
;	ymin2:		imageplane: lower border in y-direction [mm]
;	ymax2:		imageplane: upper border in y-direction [mm]
;
; OUTPUTS:
;     	beam:		initial fields are overwritten with the new values
;
;
; KEYWORDS:
;	None.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;       'libphase4idl.so' required! 
;       see also 'phainit.pro' -> '!phalib' must be defined correctly
;
; MODIFICATION HISTORY:
;      April 12, 2010, SG, initial version
;
;-

result=1
result = call_external(!phalib,'phaPropFkoe',$
			beam,  $
			double(dist), $
      double(dista),$
      double(angle),$
      LONG(mode),$
      surffilename,$
      nz2, double(zmin2), double(zmax2),$
      ny2, double(ymin2), double(ymax2),$
      /I_VALUE,/CDECL,/AUTO_GLUE,/IGNORE_EXISTING_GLUE)

END
