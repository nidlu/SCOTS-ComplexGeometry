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
tip = 2; % tilt for one of the petals
curvatureRadius_mm = 850; % radius of curvature in mm
curvatureRadius = curvatureRadius_mm / image_mm_per_px; % radius of curvature in pixels

% Create a grid
[x, y] = meshgrid(1:ncols, 1:nrows);
y = flip(y);

% Create the mask and depth map
mask = zeros(nrows, ncols);
u = zeros(nrows, ncols);
for i = 1:n_petals
    % Calculate the angle for each point in the grid
    angle = atan2(y-center(2), x-center(1));
    angle(angle<0) = angle(angle<0) + 2*pi;  % Convert negative angles to positive
    
    % Calculate the radius for each point in the grid
    rad = sqrt((x-center(1)).^2 + (y-center(2)).^2);
    
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
    u(in_petal) = curvatureRadius - sqrt(curvatureRadius^2 - rad(in_petal).^2);
    
    % Apply the tip to one of the petals
    if i == 3
        in_petal_tip = in_petal & (rad > tiltStartRadius); % apply tilt only after tiltStartRadius
        u(in_petal_tip) = u(in_petal_tip) + tip*(rad(in_petal_tip)-tiltStartRadius)/(radius-tiltStartRadius);
    end
    if i == 4
        in_petal_tip = in_petal & (rad > tiltStartRadius); % apply tilt only after tiltStartRadius
        u(in_petal_tip) = u(in_petal_tip) - tip*(rad(in_petal_tip)-tiltStartRadius)/(radius-tiltStartRadius);
    end
end

imagesc(u);colorbar;
% Compute the gradients in the u- and v-directions
[p, q] = gradient(u);
