function z=calcul_mode_zernike_Malacara2(index,rho,theta)
%
% This functions calculates the value of the Zernike polynom, the number of
% which is given by index at points defined by the arrays rho and theta
% (cylindrical coordinates).  The "Modified Malacara" convention is used:
% The numbering of the modes is kept BUT the normalization is changed so as
% to be able to use the coefficients to compute the RMS error.
%
% Use: z=calcul_mode_zernike_Malacara2(index,rho,theta)
%
%   index is the order of the polynom (Malacara's convention). This version
%   supports an arbitrary number of modes. Caution: the indices start at 0
%   (piston).
%   
%   rho contains the radial coordinates of the nodes of interest (scalar,
%   vector or 2D array - same size as theta).
%
%   theta contains the azimuthal coordinates of the nodes of interest
%   (scalar, vector or 2D array - same size as rho).
%
%   z contains the field of values over the corresponding mesh. The size is
%   the same as that of rho and theta.
%
% For a short discussion about the conventions, refer to the internal note
% "Conventions for Zernike modes".
%
% Last update: 07/12/2011


%Identification of radial and tangential degrees
nm=(-1+sqrt(8*index+1))/2-mod((-1+sqrt(8*index+1))/2,1);
d=index-nm*(nm+1)/2;
lm=nm-2*d;
mm=(nm-abs(lm))/2;

% Radial term
R=0;
for s=0:1:mm
    R=R+(-1)^(s)*(factorial(nm-s))/(factorial(s)*factorial(mm-s)*factorial(nm-mm-s)).*rho.^(nm-2*s); 
end

% Azimuthal term
if (lm > 0)
    U=sin(lm*theta);
else
    U=cos(lm*theta);
end

% Normalization
if (lm==0)
    adim=sqrt((nm+1));
else
    adim=sqrt(2*(nm+1));
end

z=adim*R.*U;


% Based on function 'eva_pol_zer.m' that uses Malacara's (unmodified)
% convention.
