addpath('..');
addpath('../Inpaint_nans');
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

% Wrap phase map to be in the range -pi to pi
wrappedPhase = mod(phaseMap, 2*pi) - pi;

% Mask the wrapped phase map
maskedWrappedPhase = wrappedPhase;
maskedWrappedPhase(~mask) = NaN;

interpMaskedWrappedPhase = inpaint_nans(maskedWrappedPhase);

% Unwrap the interpolated phase map using the mask
unwrappedPhase = phase_unwrap(interpMaskedWrappedPhase, mask);
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
