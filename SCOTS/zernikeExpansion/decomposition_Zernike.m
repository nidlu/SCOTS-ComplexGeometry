function coefs_Zernike=decomposition_Zernike(rho,theta,W_in,nb_coefs)
%
%
%

nb_pts_max=size(rho,1)*size(rho,2);

W_in=reshape(W_in,nb_pts_max,1);
rho=reshape(rho,nb_pts_max,1);
theta=reshape(theta,nb_pts_max,1);

mask_W=isnan(W_in);

idx_temp=zeros(nb_pts_max,1);
compteur=0;
for tt=1:1:nb_pts_max
    if(mask_W(tt)==0)
        compteur=compteur+1;
        idx_temp(compteur)=tt;
    end
end
idx_pts=idx_temp(1:compteur);
clear idx_temp compteur;


W_in=W_in(idx_pts);
rho=rho(idx_pts);
theta=theta(idx_pts);


A=zeros(length(rho),nb_coefs);
for tt=1:1:nb_coefs
    A(:,tt)=calcul_mode_zernike_Malacara2(tt-1,rho,theta);
end


% A_inv=pseudo_inverse_v2(A,0);
% 
% coefs_Zernike=A_inv*W_in;
coefs_Zernike=A\W_in;