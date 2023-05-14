%% integrateShape
function integrateShape(aqPar)
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
    zinit = zeros(size(w_x_0)); % least-squares initialization
    mu = 45; %45 Regularization weight for discontinuity set
    epsilon = 0.001; % Should be close to 0
    tol = 1e-8; %1e-6 Stopping criterion
    maxit = 1000; % Stopping criterion 
    
    Omega = ~isnan(w_x_0) & ~isnan(w_y_0);
    %grad up, grad right(smoothintegradients assumesdown,right)
    w = mumford_shah_integration(-w_y_0,w_x_0,Omega,lambda,z0,mu,epsilon,maxit,tol,zinit);
    
    %% plot 
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


%     % Compute linear gradients in x and y directions
%     lin_grad_x = X .* mean(w_x_0, 'all');
%     lin_grad_y = Y .* mean(w_x_0, 'all');
% 

%     % Create meshgrid for linear gradient computation
%     [X, Y] = meshgrid(1:size(w_x_0, 2), 1:size(w_x_0, 1));
% 
%     
%     % Subtract linear gradients from w_x_0
%     w_x_0_subtracted = w_x_0 - lin_grad_x - lin_grad_y;

% 
%     % Plot the subtracted w_x_0
%     figure;
%     imagesc(w_x_0_subtracted);
%     colorbar;
%     title('w_x_0 after subtracting linear gradients');
%     xlabel('x');
%     ylabel('y');
%     saveas(gcf,[aqPar.testName '/postprocessing/w_x_0_subtracted.png']);
