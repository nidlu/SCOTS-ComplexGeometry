addpath('..');
radius = 100;
innerRadius = 30;
petalStartRadius = 40;
center = [100,100];
gapWidth = 4;
n_petals = 6;
imageSizeX = 200;
imageSizeY = 200;

mask = petalMask(radius, innerRadius, petalStartRadius, center,...
                            gapWidth, n_petals, imageSizeX, imageSizeY);
imagesc(mask); colorbar; title('Mask'); pause(1); % display the mask

% Create a phase map from 0 to 40
phaseMap = linspace(0, 40, numel(mask));
phaseMap = reshape(phaseMap, size(mask));

% Set masked values to zero
phaseMap(~mask) = 0;

% Create expanded mask
% se = strel('disk', 5);
% expandedMask = imdilate(mask, se);

% Find the nearest valid (unmasked) value for each masked location in the expanded mask
[X, Y] = meshgrid(1:size(mask, 2), 1:size(mask, 1));
[Xm, Ym] = meshgrid(1:size(mask, 2), 1:size(mask, 1));
% Xm(~expandedMask) = NaN;
% Ym(~expandedMask) = NaN;
nearestX = round(griddata(X(:), Y(:), Xm(:), X, Y, 'nearest'));
nearestY = round(griddata(X(:), Y(:), Ym(:), X, Y, 'nearest'));

% Set masked values in the phase map to the nearest valid value
for i = 1:size(mask, 1)
    for j = 1:size(mask, 2)
        if ~mask(i,j)
            if ~isnan(nearestY(i,j)) && ~isnan(nearestX(i,j))
                phaseMap(i,j) = phaseMap(nearestY(i,j), nearestX(i,j));
            end
        end
    end
end


% Wrap phase map to be in the range -pi to pi
wrappedPhase = mod(phaseMap, 2*pi) - pi;

% Unwrap the phase map using the mask
unwrappedPhase = phase_unwrap(wrappedPhase, mask);
unwrappedPhase(~mask) = NaN;

% Create a display version of the unwrapped phase map that has the same range as the wrapped phase map
displayUnwrappedPhase = mod(unwrappedPhase, 2*pi) - pi;

% Display the original, wrapped, and unwrapped phase maps
figure; imagesc(phaseMap); colorbar; title('Original Phase Map'); pause(1);
figure; imagesc(wrappedPhase); colorbar; title('Wrapped Phase Map'); pause(1);
figure; imagesc(unwrappedPhase); colorbar; title('Unwrapped Phase Map');
figure; imagesc(displayUnwrappedPhase); colorbar; title('Unwrapped Phase Map (display version)');

% Compare the unwrapped phase map with the original one
diffPhase = unwrappedPhase - phaseMap;
figure; imagesc(diffPhase); colorbar; title('Difference Between Unwrapped and Original Phase');
