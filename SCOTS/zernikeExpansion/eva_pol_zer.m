%Version 2: Optimized with vector operations
%Gon�alo Rodrigues, February 27, 2006


function [z]=eva_pol_zer(no,r_i,th_i);

%no: order of polynome according to Malacara
%r_i,th_i polar coordinates for evaluating the polinomes

%Identification of radial and tangential degrees
nm=(-1+sqrt(8*no+1))/2-mod((-1+sqrt(8*no+1))/2,1);
d=no-nm*(nm+1)/2;
lm=nm-2*d;
mm=(nm-abs(lm))/2;

R=0;

% nm
% lm
% mm

for s=0:mm

%     'f nm-s'
%     factorial(nm-s)
%     'f s'
%     factorial(s)
%     'f mm-s'
%     factorial(mm-s)
%     'f nm-mm-s'
%     nm-mm-s
%     factorial(nm-mm-s)
    R=R+(-1)^(s)*(factorial(nm-s))/(factorial(s)*factorial(mm-s)*factorial(nm-mm-s)).*r_i.^(nm-2*s); 
end

if (lm > 0)
    U=R.*sin(lm*th_i);
else
    U=R.*cos(lm*th_i);
end

if (lm==0)
    adim=1/sqrt(pi/((nm+1)));
else
    adim=1/sqrt(pi/(2*(nm+1)));
end

z=adim*U;

'no';
no;
'Zmax';
adim;

'ver max';
max(max(z));

return



        


