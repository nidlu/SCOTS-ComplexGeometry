clear;
clc;
close all;

pupil_diameter=0.1;

% For NIMO Jacobian Matrix
N_Jacobian=200;

% For Display The Result
N_DISPLAY=500;

X=[-pupil_diameter/2:pupil_diameter/(N_Jacobian-1):pupil_diameter/2];
Lx=length(X);
Y=[-pupil_diameter/2:pupil_diameter/(N_Jacobian-1):pupil_diameter/2];
Ly=length(Y);

X_d=[-pupil_diameter/2:pupil_diameter/(N_DISPLAY-1):pupil_diameter/2];
Lx_d=length(X_d);
Y_d=[-pupil_diameter/2:pupil_diameter/(N_DISPLAY-1):pupil_diameter/2];
Ly_d=length(Y_d);

[xgrid,ygrid]=meshgrid(X,Y);
[xgrid_d,ygrid_d]=meshgrid(X_d,Y_d);

x=reshape(xgrid,length(xgrid)^2,1);
x_d=reshape(xgrid_d,length(xgrid_d)^2,1);
y=reshape(ygrid,length(ygrid)^2,1);
y_d=reshape(ygrid_d,length(ygrid_d)^2,1);

%%

rho=((xgrid.^2+ygrid.^2).^0.5)/(pupil_diameter/2);
theta=atan2(ygrid,xgrid);

if (1)
    
    nb_zernike_mode_show=10;
    nb_coefs=2*nb_zernike_mode_show;

    for i=1:nb_zernike_mode_show
        Z_target(:,:,i)=norm_eva_pol_zer(i,rho,theta,xgrid,ygrid,pupil_diameter);

        PV(i)=max(max(Z_target(:,:,i)))-min(min(Z_target(:,:,i)));
        RMS(i)=get_mean_RMS_v2(Z_target(:,:,i),[]);

        figure(i);
        
        surf(xgrid,ygrid,Z_target(:,:,i));
        colorbar;
        colormap jet;
        view(0,90);
        shading interp;
        xlabel('x [m]');
        ylabel('y [m]');
        zlabel('W [m]');
        title(['Zernike Mode ',num2str(i),'  PV=',num2str(PV(i)),' RMS=',num2str(RMS(i))]);

        axis([-pupil_diameter pupil_diameter -pupil_diameter pupil_diameter]/2);
        axis square;
        
        box on;
        coefs_Zernike(:,i)=decomposition_Zernike(rho,theta,Z_target(:,:,i),nb_coefs);

    end

end