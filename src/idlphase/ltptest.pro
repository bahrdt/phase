
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1) komplettes phase4idl compilieren mit:  
; idl aufrufen
; "@phase4idl.compile_all.idl"

 device,decomposed=0
 loadct,39
 !QUIET =1

;PHASE
 @phase4idl.compile_all.idl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print,''
print,'--------------------------------------------------------------'
print,'     LTPtest
print,'--------------------------------------------------------------'

;;PHASE: notwendiger Initialisierungsaufruf (nur einmalig in IDL-session noetig)
 phainit


;;; allgemeine Settings
tmpfile = 'mysource'
beamlinefile = 'myltp.phase' 
cmode =3

;;; Parameter fuer Darstellungen
winx = 500   ; window size x
winy = 350   ; window size y 
myxp = 0
myyp = 600
sourcecheck = 1
nz = 256     ; array size
ny = 256

uxr = [-20,20]     ; size [mm] contourplot (nicht benutzt) 
uyr = [-20,20]     ; size [mm] contourplot (nicht benutzt) 
userlimits = 1     ; USER-Einstellungen fuer Contourplot werden aktiv

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; physikal. Parameter
waist = 1.5D       ; gaussian beam waist [mm]
size = waist*10.  ; size of sourcefield [mm]
  size= 10.0D
lambda = 632.8   ; wavelength [nm]

dist1 = 100.0      ; distance [mm] to "slit plane"
dist2 = 500        ; distance [mm] from "slit plane" to "image plane"
dist2a = 200      ; distance [mm] from "slit plane" to "2. image plane"
nearfield1 = 1
nearfield2 = 1
phi=180D
bild_invers= 0
nur_phasen_gitter = 0D   ; 1 ... entspricht Spiegel mit Phasenstufe (Amplituden bleiben erhalten)
                         ;        (Phasen werden gemaesz definiertem Muster veraendert) 
                         ; 0 ... Amplituden werden gemaesz definiertem Muster Null gesetzt
apertur = 230

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generierung von Mustern (Phasen-MUSTER)

;bild = read_bmp('b1_face.bmp')
;bild = read_bmp('b2_slitrect.bmp')
;bild = read_bmp('b3_freestyle.bmp')
;bild = read_bmp('b4_circle.bmp')
;bild = read_bmp('b4a_circle_small.bmp')
bild = read_bmp('b5_cross.bmp')
;bild = read_bmp('b6_dots.bmp')
;bild = read_bmp('b7_quarter.bmp')
;bild = read_bmp('b8_slits.bmp')
;bild = read_bmp('b9_half.bmp')
;bild[*,0:128]=shift(bild[*,0:128],64)
;bild = read_bmp('b10_beam.bmp')

 ;Spezial-Mehrfachspalt
 my = reform([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] # replicate(1,8),256)
 ;bild = my # replicate(1,256)
 my = reform([1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0] # replicate(1,16),256)
 ;bild2 = my # replicate(1,256)
 ;my = reform([1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0] # replicate(1,16),256)
 ;my = reform([1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0] # replicate(1,16),256)
 ;bild = my # replicate(1,256)
 ;bild = shift(bild,8,0) 
 ;bild = bild * rotate(bild,1)

 ;Doppespalt
 ;bild  = make_array(256,256,/double)
 ;bild2 = make_array(256,256,/double) ; Amplituden-Bild
 abstand = 7
 breite =  40
 ;bild[128-abstand/2-breite+1:128-abstand/2.,*]  = 1D
 ;bild[128+abstand/2.:128+abstand/2+breite-1,*]  = 1D
 ;bild2[128-abstand/2-breite+1:128-abstand/2.,*] = 1D
 ;bild2[128+abstand/2.:128+abstand/2+breite-1,*] = 1D


 ;;Ergebnis-Sinus
 ;my = sin(findgen(256)/256. * !dpi *21.1)
 ;my2 = my # replicate(1,256) 
 ;surface,shift(abs(fft(my2,/inverse)),128,128),/zlog,charsize=2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; evtl. Bild invertieren und Bild auf size 256x256 bringen 
bild = bild - min(bild)
bild = bild /max(bild)
IF (bild_invers EQ 1) THEN bild = bild *(-1.) +1.
IF (bild_invers EQ 1) THEN bild2 = bild2 *(-1.) +1.
bild = congrid(bild,nz,ny)


;PHASE: generate new Gaussian-Beam 
;                  ( nz ,  zmin ,   zmax ,  ny ,  ymin ,  ymax , waist, dist[mm] , lambda[nm])
 beam=phaSrcWFGauss( nz,-size/2, size/2  ,  ny ,-size/2, size/2, waist,        0 , lambda ,1,1,0)
 beamsource=beam

; calculation of Raleigh range
 raleigh = !DPI* waist^2/lambda * 1e6 
 print,"Raleigh range [mm] : ", raleigh
 print,"Distances [mm]     : ",dist1,dist2,dist2a
 print,"Nearfield [boolean]: ",nearfield1,nearfield2,nearfield2

; Anzeige Gauss-Source
;IF ((sourcecheck EQ 1) AND (!D.NAME NE 'PS') ) THEN  window,/free
;IF (sourcecheck EQ 1) THEN  phaIntensitySurface,beam,'Gauss-Source '

;PHASE:  Propagate the field with the FFT-near/far-field-propagator
;                     distance/[mm]
 IF (nearfield1 EQ 1) THEN phaPropFFTnear, beam,  dist1 ELSE phaPropFFTfar, beam, dist1
 beamslit=beam
 xgrenze=beam.iezrex
 ygrenze=beam.iezrey

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Phasen in 'Spaltebene' bearbeiten

; Variante 1: Haelfte des Strahles 180 Grad Phase schieben
  ; ere = beam.zezre(0:xgrenze/2-1,*)
  ; eim = beam.zezim(0:xgrenze/2-1,*)
  ; beam.zezre(0:xgrenze/2-1,*)=ere * cos(phi *!DPI/180D) - eim * sin(phi *!DPI/180D)
  ; beam.zezim(0:xgrenze/2-1,*)=ere * sin(phi *!DPI/180D) + eim * cos(phi *!DPI/180D)

; Variante 2: ein inverser Spalt 
  ; pix=5
  ; ere = beam.zezre(xgrenze/2-1-pix:xgrenze/2-1+pix,*)
  ; eim = beam.zezim(xgrenze/2-1-pix:xgrenze/2-1+pix,*)
  ; beam.zezre(xgrenze/2-1-pix:xgrenze/2-1+pix,*)= ere * cos(phi *!DPI/180D) - eim * sin(phi *!DPI/180D)
  ; beam.zezim(xgrenze/2-1-pix:xgrenze/2-1+pix,*)= ere * sin(phi *!DPI/180D) + eim * cos(phi *!DPI/180D)

; Variante 3: Bilder aufmultiplizieren 
  ; beam.zezre = beam.zezre * bild
  ; beam.zezim = beam.zezim * bild

; Variante 4: Bilderbereiche Phase schieben
  bildall = beam.zezre * 0D
  bildall(0:xgrenze-1,0:ygrenze-1) = bild
  ere = beam.zezre
  eim = beam.zezim
   datap0 = atan(beam.zezim/beam.zezre)*180D/!DPI
   beam0re = beam.zezre & beam0im = beam.zezim

  ere_sh = ere * cos(phi *!DPI/180D) - eim * sin(phi *!DPI/180D)
  eim_sh = ere * sin(phi *!DPI/180D) + eim * cos(phi *!DPI/180D)
  idx = where(bildall GT 0.5)
  beam.zezre(idx) = ere_sh(idx) * nur_phasen_gitter
  beam.zezim(idx) = eim_sh(idx) * nur_phasen_gitter 
  ;beam.zezre = beam.zezre *bild2
  ;beam.zezim = beam.zezim *bild2

  ; Stand in beam1xx merken
  beam1re = beam.zezre & beam1im = beam.zezim




;Anzeigen der Phasenbearbeitung

loadct,39
IF ( (sourcecheck EQ 1) AND (!D.NAME NE 'PS') ) THEN window,xsize=winx,ysize=winy,/free,xpos=myxp,ypos=myyp
 ;IF (sourcecheck EQ 1) THEN phaIntensitySurface,beam,'Imageplane'

 intens1 =(beamsource.zezre^2 + beamsource.zezim^2)(0:xgrenze-1,0:ygrenze-1)
 intens2 =(beamslit.zezre^2 + beamslit.zezim^2)(0:xgrenze-1,0:ygrenze-1)

!p.multi=[0,2,1]
 z=get_pha_src4_axis_z(beamsource)
 y=get_pha_src4_axis_y(beamsource)
 IF (sourcecheck EQ 1) THEN contour,intens1,z,y, $
                             /iso,nlevels=50,xst=1,yst=1,thick=3,$ 
           title="Source !C"+string(format ='(A,f7.1,A,f7.1)',$ 
           'waist : ',waist,' mm!Clambda [nm] : ',lambda),$
           zrange=[0,max(intens1)] ,/fill,$
	   xtitle='[mm]',ytitle='[mm]'

 z=get_pha_src4_axis_z(beamslit)
 y=get_pha_src4_axis_y(beamslit)
 IF (sourcecheck EQ 1) THEN contour,intens2,z,y, $
                             /iso,nlevels=50,thick=3,$
                             xst=1,yst=1,$ 
    title="Source@Slit!C"+string(format ='(A,f8.1,A,I1)','Distanz :!C',dist1,' mm!CNahfeld : ',nearfield1),$
    zrange=[0,max(intens2)] ,/fill,$
    xtitle='[mm]',ytitle='[mm]'
!p.multi=0


IF (!D.NAME NE 'PS') THEN window,xsize=winx,ysize=winy,/free,xpos=myxp+50,ypos=myyp-50
loadct,0
contour,bild,z,y,/fill,/iso,nlevels=20,xst=1,yst=1,zrange=[-0.1,1.1], $
    title='Phasenschiebenes-Muster !c@ Slit / [degree]: '+ string(format='(f5.1)',phi),$
    pos = [0.2,0.15,0.9,0.85],$
    xtitle='[mm]',ytitle='[mm]'

loadct,39
;IF (!D.NAME NE 'PS') THEN window,xsize=winx,ysize=winy,/free,xpos=myxp+100,ypos=myyp-100
;datap = atan(beam.zezim/beam.zezre)*180D/!DPI
;contour,datap,z,y,/fill,/iso,nlevels=40,xst=1,yst=1,$
;   title="Phasenbild @ Slit ",$
;    pos = [0.2,0.15,0.9,0.85],$
;    xtitle='[mm]',ytitle='[mm]'


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;PHASE: weiter propagieren
beam2a = beam
IF (nearfield2 EQ 1) THEN phaPropFFTnear, beam,  dist2 ELSE phaPropFFTfar, beam, dist2
;PHASE: noch weiter propagieren
IF (nearfield2 EQ 1) THEN phaPropFFTnear, beam2a,  dist2a ELSE phaPropFFTfar, beam2a, dist2a


;phaIntensitySurface,beam,'Imageplane '
z=get_pha_src4_axis_z(beam)
y=get_pha_src4_axis_y(beam)
intens =(beam.zezre^2 + beam.zezim^2)(0:xgrenze-1,0:ygrenze-1)


IF (!D.NAME NE 'PS') THEN window,xsize=winx,ysize=winy,/free,xpos=myxp+150,ypos=myyp-150
data = (intens)
IF (userlimits EQ 1) THEN xr = uxr ELSE xr = [min(z),max(z)]
IF (userlimits EQ 1) THEN yr = uyr ELSE yr = [min(y),max(y)]

contour,(data),z,y,/fill,nlevels=40,pos=[0.1,0.4,0.7,0.8],xst=1,yst=1,$
   title="Intensity@Imageplane / !C"+string(format ='(A,f8.1,A,I1)','Distanz : ',dist2, $
         ' mm!CNahfeldpropagator : ',nearfield2),$
   xrange=xr,yrange=yr
 plot,y,total(data,2),/noerase,pos =[0.1,0.1,0.7,0.3],xst=1,xrange=xr
 plot,total(data,1),z,/noerase,pos =[0.8,0.4,0.95,0.8],xticks=1,yst=1,yrange=yr
print
;print,"limits z,y [mm] : ",min(z),max(z),min(y),max(y)

;;
;phaIntensitySurface,beam,'2. Imageplane '
z=get_pha_src4_axis_z(beam2a)
y=get_pha_src4_axis_y(beam2a)
intens =(beam2a.zezre^2 + beam2a.zezim^2)(0:xgrenze-1,0:ygrenze-1)

IF (!D.NAME NE 'PS') THEN window,xsize=winx,ysize=winy,/free,xpos=myxp+200,ypos=myyp-200
data = (intens)
IF (userlimits EQ 1) THEN xr = uxr ELSE xr = [min(z),max(z)]
IF (userlimits EQ 1) THEN yr = uyr ELSE yr = [min(y),max(y)]

;loadct,0
;stretch,0,255,0.3

contour,data,z,y,/fill,nlevels=40,pos=[0.1,0.4,0.7,0.8],xst=1,yst=1,$
   title="Intensity@ 2. Imageplane / !C"+string(format ='(A,f8.1,A,I1)','Distanz : ',dist2a, $
         ' mm!CNahfeldpropagator : ',nearfield2),$
         xrange=xr,yrange=yr
 plot,y,total(data,2),/noerase,pos =[0.1,0.1,0.7,0.3],xst=1,xrange=xr
 plot,total(data,1),z,/noerase,pos =[0.8,0.4,0.95,0.8],xticks=1,yst=1,yrange=yr
print
;print,"limits z,y [mm] : ",min(z),max(z),min(y),max(y)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Spiele mit einer Apertur
beamnow = DCOMPLEX(beam2a.zezre,beam2a.zezim)
aperdummy = real_part(beamnow)*0D +1D
aperdummy = aperture(aperdummy,apertur)
beamnow = aperture(beamnow,apertur)

beamnow_fft = fft(beamnow,1)
beamnow_2fft = fft(beamnow_fft,-1)
beamnow_fft_int = abs(beamnow_fft)^2
beamnow_2fft_int = abs(beamnow_2fft)^2

;IF (!D.NAME NE 'PS') THEN window,xsize=winx,ysize=winy,/free,xpos=myxp+250,ypos=myyp-250
;!P.MULTI=[0,2,1]
; contour,abs(beamnow)^2,z,y,/fill,nlevels=20,/iso,$
;         title="Apertur !C2. Imageplane "+string(format='(I4)',apertur) ;,$
;         ;xrange=xr,yrange=yr
; contour,aperdummy,z,y,/overplot,level=0.5
;
; contour,shift(beamnow_fft_int,128,128),/fill,nlevels=20,$
;         title="FFT nach !C2. Imageplane ",/iso
;
; contour,shift(beamnow_2fft_int,0,0),/fill,nlevels=20,$
;         title='2. FFT nach !C2. Imageplane ',/iso  ;,$
;         ;xrange=xr,yrange=yr
;!P.MULTI=0
