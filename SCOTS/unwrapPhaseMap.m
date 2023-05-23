%% unwrapPhaseMap
function unwrapPhaseMap(aqPar)
    wrappedMapV = readmatrix([aqPar.testName '/postprocessing/wrappedMapV.txt']);
    wrappedMapH = readmatrix([aqPar.testName '/postprocessing/wrappedMapH.txt']);
    
    mask = ones(size(wrappedMapV));
    mask(isnan(wrappedMapV))=0;
    
    interpWrappedMapV = inpaint_nans(wrappedMapV);
    interpWrappedMapH = inpaint_nans(wrappedMapH);
                              
    unwrappedPhaseV = phase_unwrap(interpWrappedMapV,mask);
    unwrappedPhaseH = phase_unwrap(interpWrappedMapH,mask);
    
    unwrappedPhaseV(~mask) = NaN;
    unwrappedPhaseH(~mask) = NaN;
    
    writematrix(unwrappedPhaseV,[aqPar.testName '/postprocessing/unwrappedMapV.txt']);
    writematrix(unwrappedPhaseH,[aqPar.testName '/postprocessing/unwrappedMapH.txt']);
    
    %%
    figure()
    surf(unwrappedPhaseV);
    set(gca, 'XDir','reverse')
    title("Vertical unwrapped phase map");
    shading interp
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    set(gcf,'Position',[400 200 450 350])
    numRepsTop = max(max(unwrappedPhaseV))/(2*pi);
    numRepsBottom = min(min(unwrappedPhaseV))/(2*pi);
    n = 50;
    mapTemplate = parula(n);
    cmapTop    = repmat(mapTemplate, floor(numRepsTop), 1); % Create new colormap consisting of 5 cyclical colormaps.
    cmapBottom = repmat(mapTemplate, floor(abs(numRepsBottom)), 1);
    nLeftTop    = round((numRepsTop-floor(numRepsTop))*n); %the amount of part-colormaps cycles left
    nLeftBottom = abs(round((numRepsBottom-ceil(numRepsBottom))*n));
    cmapTopLeft = mapTemplate(1:nLeftTop,:);
    if((n-nLeftBottom)~=0)
        cmapBottomLeft = mapTemplate((n-nLeftBottom):end,:);
    else
        cmapBottomLeft = double.empty(0,3);
    end
    cmap = [cmapBottomLeft; cmapBottom; cmapTop; cmapTopLeft];
    % Let's see it!
    colormap(cmap);
    T = [flip(0:-2*pi:min(min(unwrappedPhaseV))), (2*pi:2*pi:max(max(unwrappedPhaseV)))];
    TL=arrayfun(@(x) sprintf('%.2f',x),T,'un',0);
    colorbar('XTick', T, 'TickLabels',TL);
    view(2)
    saveas(gcf,[aqPar.testName '/postprocessing/unwrappedMapV.png'])
    
    figure()
    surf(unwrappedPhaseH);
    set(gca, 'XDir','reverse')
    title("Horizontal unwrapped phase map");
    shading interp
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    set(gcf,'Position',[400 200 450 350])
    numRepsTop = max(max(unwrappedPhaseH))/(2*pi);
    numRepsBottom = min(min(unwrappedPhaseH))/(2*pi);
    n = 50;
    mapTemplate = parula(n);
    cmapTop    = repmat(mapTemplate, floor(numRepsTop), 1); % Create new colormap consisting of 5 cyclical colormaps.
    cmapBottom = repmat(mapTemplate, floor(abs(numRepsBottom)), 1);
    nLeftTop    = round((numRepsTop-floor(numRepsTop))*n); %the amount of part-colormaps cycles left
    nLeftBottom = abs(round((numRepsBottom-ceil(numRepsBottom))*n));
    cmapTopLeft = mapTemplate(1:nLeftTop,:);
    cmapBottomLeft = mapTemplate((n-nLeftBottom):end,:);
    cmap = [cmapBottomLeft; cmapBottom; cmapTop; cmapTopLeft];
    % Let's see it!
    colormap(cmap);
    T = [flip(0:-2*pi:min(min(unwrappedPhaseV))), (2*pi:2*pi:max(max(unwrappedPhaseV)))];
    TL=arrayfun(@(x) sprintf('%.2f',x),T,'un',0);
    colorbar('XTick', T, 'TickLabels',TL);
    view(2)
    saveas(gcf,[aqPar.testName '/postprocessing/unwrappedMapH.png'])
end