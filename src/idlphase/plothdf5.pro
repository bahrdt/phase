;; -*-idlwave-*-
;  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseidl/plothdf5.pro
;  Date      : <25 Mar 13 10:51:13 flechsig> 
;  Time-stamp: <26 Mar 13 15:16:31 flechsig> 
;  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

;  $Source$ 
;  $Date$
;  $Revision$ 
;  $Author$ 

pro plothdf5, fname, genesis=genesis, phase=phase, png=png, psd=psd, limit=limit, _extra=extra
;+
; NAME:
;   plothdf5
;
;
; PURPOSE:
;   plot a hdf5 file of type phase_hdf5 or genesis_hdf5, wrapper for
;   other scripts
;
;
; CATEGORY:
;   phase_plot
;
;
; CALLING SEQUENCE:
;   plothdf5, filename, [/genesis] [/phase] [/pst] [,/png]
;
;
; INPUTS:
;   fname: filename
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;   genesis: genesis_hdf5 default: phase_hdf5
;   limit:   limit the number of plots to limit
;   phase:   phase hdf5
;   png:     save png files
;   pst:     psd plot (phase intensity output) 
;
;
; OUTPUTS:
;
;
;
; OPTIONAL OUTPUTS:
;
;
;
; COMMON BLOCKS:
;
;
;
; SIDE EFFECTS:
;
;
;
; RESTRICTIONS:
;
;
;
; PROCEDURE:
;
;
;
; EXAMPLE:
;   plothdf5, 'filename.h5', /genesis
;
;
; MODIFICATION HISTORY:
;    25.3.13 UF
;-

if keyword_set(psd) then begin
    plothdf5_pst, fname, png=png, _extra=extra
    return
endif

if keyword_set(phase) then begin
    plothdf5_phase_source, fname, png=png, limit=limit, _extra=extra
    return
endif

if keyword_set(genesis) then begin
    plothdf5_genesis_source, fname, png=png, limit=limit, _extra=extra
    return
endif

print,'error: you have to select a keyword (/genesis, /phase, /psd)'
return
end
;; end
