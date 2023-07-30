clc; clear all;

% Load your measurement data
measPoints = readmatrix('samPoints');
measEdges = readmatrix('samEdges');
measTriangles = readmatrix('samTriangles');
measDeflection = readmatrix('samDeflection')';

% Extract the x and y coordinates
X_mm = measPoints(1, :)*1000;
Y_mm = measPoints(2, :)*1000;
measDeflection_mm = measDeflection*1000;

% Compute the parabolic surface at the measurement points
RoC = 2500; % Replace this with your actual radius of curvature
Z_parabolic = (X_mm.^2 + Y_mm.^2) / (2 * RoC);

% Add the measurement deflections
um_amplitude = 100;
Z_mm = Z_parabolic% + um_amplitude*measDeflection_mm/10;

% Create a triangulation object using the provided triangle data
faces = measTriangles(1:3,:); % adjust as needed based on the structure of measTriangles
vertices = [X_mm; Y_mm; Z_mm];

% Create a triangulation object
TR = triangulation(faces', vertices');

% Save the triangulation object as an STL file
stlwrite(TR, 'tipDisplacementPetal_RoC2.5_no_aberration.stl');
