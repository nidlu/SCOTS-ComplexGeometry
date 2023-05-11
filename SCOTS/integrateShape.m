%% integrateShape
function f = integrateShape(aqPar)
    %read slopes
    w_x_0 = readmatrix([aqPar.testName '/postprocessing/w_x_0.txt']);
    w_y_0 = readmatrix([aqPar.testName '/postprocessing/w_y_0.txt']);
    
    % Scale the slopes by the grid spacing
    w_x_0 = aqPar.image_mm_per_px * w_x_0;
    w_y_0 = aqPar.image_mm_per_px * w_y_0;
    
    % Set optimization parameters
    lambda = 1e-6*ones(size(w_x_0)); % Uniform field of weights (nrows x ncols)
    z0 = zeros(size(w_x_0)); % Null depth prior (nrows x ncols)
    solver = 'pcg'; % Solver ('pcg' means conjugate gradient, 'direct' means backslash i.e. sparse Cholesky) 
    precond = 'ichol'; % Preconditioner ('none' means no preconditioning, 'ichol' means incomplete Cholesky, 'CMG' means conjugate combinatorial multigrid -- the latter is fastest, but it need being installed, see README)

    Omega = ~isnan(w_x_0);
    %grad up, grad right(smoothintegradients assumesdown,right)
    w = smooth_integration(-w_y_0,w_x_0,Omega,lambda,z0,solver,precond);
    
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, w); shading interp; view(2); 
    PV = max(w,[],'all')-min(w,[],'all');
    title(sprintf("Measured height map, PV: %.2f mm",PV))
    hc=colorbar;
    title(hc,'mm');
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    set(gcf,'Position',[400 200 450 350])
    saveas(gcf,[aqPar.testName '/postprocessing/measuredHeightMap.png'])

    writematrix(w,[aqPar.testName '/postprocessing/w0.txt']);
end

%     mask and integrate slopes to create surface
%     mask = isnan(w_y_0);
%     w_y_0(mask) = 0;
%     w_x_0(mask) = 0;
%     w = intgrad2(w_x_0,w_y_0, aqPar.imagePxScale, aqPar.imagePxScale);
%     hold on
%     w(mask)=NaN;
%     plot(linspace(0,1,201),w(100,:))
    %h = fspecial('average', 2);
    %w = imfilter(w, h);
    
%     plot(linspace(0,1,101),w(50,:))