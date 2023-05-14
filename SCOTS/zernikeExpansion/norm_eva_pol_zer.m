function Z_target=norm_eva_pol_zer(tt,rho,theta,xgrid,ygrid,pupil_diameter)

Z_target=eva_pol_zer(tt,rho,theta);
W_show=Z_target;

xgrid_standard=xgrid/(pupil_diameter/2);
ygrid_standard=ygrid/(pupil_diameter/2);

        for ii=1:size(xgrid_standard,1)
            for jj=1:size(ygrid_standard,1)
                distance_2=xgrid_standard(ii,jj)^2+ygrid_standard(ii,jj)^2;
                if (distance_2>1)
                    W_show(ii,jj)=NaN;
                end
            end
        end
RMS=get_mean_RMS_v2(W_show,[]);
Z_target=W_show/RMS;

% PV=max(max(W_show))-min(min(W_show));
% Z_target=W_show/PV;
end

% (tt,rho,theta,xgrid,ygrid,pupil_diameter);
