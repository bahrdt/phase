;; -*-idlwave-*-
;  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseidl/plothdf5.pro
;  Date      : <25 Mar 13 10:51:13 flechsig> 
;  Time-stamp: <03 Jun 14 11:25:50 flechsig> 
;  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

;  $Source$ 
;  $Date$
;  $Revision$ 
;  $Author$ 

pro h5_write_surf_error, fname, ename, u, w, l, verbose=verbose
;+
; NAME:
;   h5_write_surf_error
;
;
; PURPOSE:
;   write phase surface error file, units m, u can be 1d or 2d data
;
; CATEGORY:
;   phase_h5
;
; CALLING SEQUENCE:
;
; INPUTS:
;   fname: filename
;   ename: elementname
;   u:     height u(w,l)
;   w:     w
;   l:     l
;
; KEYWORD PARAMETERS:
;   verbose
;
; OUTPUTS:
;  no
;
; EXAMPLE:
;  idl> h5_write_surf_error, 'mysurface', 'm1', u, w, l
;
;
; MODIFICATION HISTORY:
;    25.6.14 UF
;-

print, 'h5_write_surf_error called'

usage= 'usage: h5_write_surf_error, fname, ename, u, w, l'


if n_params() ne 5 then begin
    print, usage
    return
endif

if SIZE(u, /N_DIMENSIONS) eq 2 then u1=double(reform(u)) else u1= double(u)
w= double(w)
l= double(l)

nw= n_elements(w)
nl= n_elements(l)
nu= n_elements(u1)

u2= reform(u1, nw, nl)
na= [nw, nl]

if nu ne (nw*nl) then begin
    print, 'error dimensions not consistent- exit'
    return
endif

file_id  = H5F_CREATE(fname)
group_id = H5G_CREATE(file_id, ename)

a_dataspace_id = H5S_create_simple(na)
u_dataspace_id = H5S_create_simple(nu)
w_dataspace_id = H5S_create_simple(nw)
l_dataspace_id = H5S_create_simple(nl)

a_dataset_id = H5D_CREATE(file_id,  'height2D',   datatype_double_id, a_dataspace_id);
u_dataset_id = H5D_CREATE(file_id,  'height_vec', datatype_double_id, u_dataspace_id);
w_dataset_id = H5D_CREATE(file_id,  'wvec',       datatype_double_id, w_dataspace_id);
l_dataset_id = H5D_CREATE(file_id,  'lvec',       datatype_double_id, l_dataspace_id);

H5D_WRITE, a_dataset_id, u2
H5D_WRITE, u_dataset_id, u1
H5D_WRITE, w_dataset_id, w
H5D_WRITE, l_dataset_id, l

H5D_CLOSE, a_dataset_id
H5D_CLOSE, u_dataset_id
H5D_CLOSE, w_dataset_id
H5D_CLOSE, l_dataset_id

H5S_CLOSE, a_dataspace_id
H5S_CLOSE, u_dataspace_id
H5S_CLOSE, w_dataspace_id
H5S_CLOSE, l_dataspace_id

H5G_CLOSE, group_id

h5f_close, file_id

print, 'wrote surface error file: ', fname

return
end
;; end
