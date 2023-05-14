% Constants
clear all; close all; clc;
image_mm_per_px = 0.7; % conversion factor from mm to pixels (change this as per your requirements)
radius_mm = 100; % reflector radius in mm
radius = round(radius_mm / image_mm_per_px); % reflector radius in pixels
innerRadius_mm = 10; % inner radius in mm
innerRadius = round(innerRadius_mm / image_mm_per_px); % inner radius in pixels
gapWidth_mm = 2; % gap width in mm
gapWidth = round(gapWidth_mm / image_mm_per_px); % gap width in pixels
petalStartRadius_mm = 20; % petal start radius in mm
petalStartRadius = round(petalStartRadius_mm / image_mm_per_px); % petal start radius in pixels
tiltStartRadius_mm = petalStartRadius_mm + 4; % tilt start radius in mm
tiltStartRadius = round(tiltStartRadius_mm / image_mm_per_px); % tilt start radius in pixels
center_mm = [radius_mm, radius_mm]; % center in mm
center = round(center_mm / image_mm_per_px); % center in pixels
nrows = radius*2;
ncols = radius*2;
n_petals = 6;
theta = linspace(0, 2*pi, n_petals+1); % angles for the petals
tip = 0.02; % tilt for one of the petals
RoC_mm = 850; % radius of curvature in mm NOTE CHANGED TO LARGE ROC
RoC = RoC_mm / image_mm_per_px; % radius of curvature in pixels

% Create a grid
[x, y] = meshgrid(1:ncols, 1:nrows);
y = flip(y);
x_mm = x*image_mm_per_px;
y_mm = y*image_mm_per_px;

% Create the mask and depth map
mask = zeros(nrows, ncols);
u = zeros(nrows, ncols);
for i = 1:n_petals
    % Calculate the angle for each point in the grid
    angle = atan2(y-center(2), x-center(1));
    angle(angle<0) = angle(angle<0) + 2*pi;  % Convert negative angles to positive
    
    % Calculate the radius for each point in the grid
    rad = sqrt((x-center(1)).^2 + (y-center(2)).^2);
    rad_mm = sqrt((x_mm-center_mm(1)).^2 + (y_mm-center_mm(2)).^2);
    
    % Calculate the gap in angle based on the radius
    angleGap = gapWidth ./ rad;
    angleGap(rad < petalStartRadius) = 0;  % no gap inside petalStartRadius
    
    % Find the pixels inside the current petal
    in_petal = (rad <= radius) & ... % inside the outer circle
        (rad > innerRadius) & ... % outside the inner circle
        (angle >= theta(i) + angleGap) & ... % left of the right boundary
        (angle < theta(i+1) - angleGap); % right of the left boundary
    
    % Update the mask
    mask(in_petal) = 1;
    
    % Update the depth map with the spherical reflector equation
    u(in_petal) = RoC_mm - sqrt(RoC_mm^2 - rad_mm(in_petal).^2);
    
    % Apply the tip to one of the petals
    if i == 3
        in_petal_tip = in_petal & (rad > tiltStartRadius); % apply tilt only after tiltStartRadius
        xx = (rad(in_petal_tip)-tiltStartRadius)/(radius-tiltStartRadius);
        u(in_petal_tip) = u(in_petal_tip) - tip*xx.^2;
    end
    if i == 4
        in_petal_tip = in_petal & (rad > tiltStartRadius); % apply tilt only after tiltStartRadius
        xx = (rad(in_petal_tip)-tiltStartRadius)/(radius-tiltStartRadius);
        u(in_petal_tip) = u(in_petal_tip) + tip*xx.^2;
    end
end
%% SLOPED REFLCETOR
% u = u+0.02*x;
% u = u+0.01*y;

u_nan = u;
u_nan(~mask)=NaN;

imagesc(u);colorbar;
% Compute the gradients in the u- and v-directions
%% changed slopes
w_x = readmatrix('C:\Users\cjgn44\Google Drive\ULB\SCOTS-ComplexGeometry/data/08_05_2023_phaseAccTest/test8_lsq_lownoise/postprocessing/w_x_0.txt');
w_y = -readmatrix('C:\Users\cjgn44\Google Drive\ULB\SCOTS-ComplexGeometry/data/08_05_2023_phaseAccTest/test8_lsq_lownoise/postprocessing/w_y_0.txt');
%[w_x, w_y] = gradient(u_nan);

gradientMask = ~isnan(w_x) & ~isnan(w_y);
gradientMaskEroded = gradientMask;

figure();imagesc(w_x);colorbar;
figure();imagesc(w_y);colorbar;
%% quadratic integration
% Set optimization parameters
lambda = 1e-6*ones(size(w_x)); % Uniform field of weights (nrows x ncols)
z0 = zeros(size(w_x)); % Null depth prior (nrows x ncols)
solver = 'pcg'; % Solver ('pcg' means conjugate gradient, 'direct' means backslash i.e. sparse Cholesky) 
precond = 'ichol'; % Preconditioner ('none' means no preconditioning, 'ichol' means incomplete Cholesky, 'CMG' means conjugate combinatorial multigrid -- the latter is fastest, but it need being installed, see README)

p = w_y; q = w_x;
p(isnan(p))=0;q(isnan(q))=0;
%grad up, grad right(smoothintegradients assumesdown,right)
w_quadratic = smooth_integration(p,q,gradientMaskEroded,lambda,z0,solver,precond);


%% mumford integration
disp('Doing Mumford-Shah integration');

zinit = w_quadratic; % least-squares initialization
zinit(isnan(zinit))=0;
mu = 45; %45 Regularization weight for discontinuity set
epsilon = 0.001; % Should be close to 0
tol = 1e-8; %1e-6 Stopping criterion
maxit = 1000; % Stopping criterion 

w_mumford = mumford_shah_integration(p,q,gradientMaskEroded,lambda,z0,mu,epsilon,maxit,tol,zinit);
%% integration constants
se = strel('square', 3); % Create a structuring element of a 3x3 square
%gradientMaskEroded = logical(imerode(mask, se)); % Erode the mask

% Find the integration constant which minimizes RMSE
integrationConstant = -mean(w_quadratic(gradientMaskEroded)-u(gradientMaskEroded));
w_quadratic = w_quadratic+integrationConstant;
% Calculate RMSE
RMSE_quadratic = sqrt(mean((w_quadratic(gradientMaskEroded)-u(gradientMaskEroded)).^2));

integrationConstant = -mean(w_mumford(gradientMaskEroded)-u(gradientMaskEroded));
w_mumford = w_mumford+integrationConstant;
% Calculate RMSE
RMSE_mumford = sqrt(mean((w_mumford(gradientMaskEroded)-u(gradientMaskEroded)).^2));

%% plotting
% 
% figure
% title("quadratic");
% finalSurfaceError = u-w_quadratic;
% finalSurfaceError(~gradientMaskEroded)=NaN;
% imagesc(finalSurfaceError);colorbar;
% 
% figure
% title("mumford");
% finalSurfaceError = u-w_mumford;
% finalSurfaceError(~gradientMaskEroded)=NaN;
% imagesc(finalSurfaceError);colorbar;

figure
title("simulated surface");
finalSurface = w_mumford;
finalSurface(~gradientMaskEroded)=NaN;
imagesc(finalSurface);colorbar;

figure
title("original surface");
finalSurface = u;
finalSurface(~gradientMaskEroded)=NaN;
imagesc(finalSurface);colorbar;





