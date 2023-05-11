%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finding the Phase from a sine dataset
% Inputs:
%   * x: x-axis in radians
%   * y: y amplitude from -1 to 1
%   * plotTrue: boolean display plot or not
% Output:
%   * phase: resulting phase
% Author: Carl Johan G Nielsen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function phase = sineFitRestricted(x,y,plotTrue)
%     fit = @(phase,x) (sin(x + phase));            % Function to fit
%     initial_guess = 0;
%     lb = -pi;  % Lower bound for phase
%     ub = pi;   % Upper bound for phase
% 
%     % Set options to suppress output to the console
%     options = optimoptions('lsqcurvefit', 'Display', 'off');
% 
%     % Using lsqcurvefit for fitting with options
%     phase = lsqcurvefit(fit, initial_guess, x, y, lb, ub, options);
% 
%     if(plotTrue)
%         figure(1)
%         plot(x,y,'b',  x,fit(phase,x), 'r')
%         ylabel("Rescaled intensity")
%         xlabel("\phi")
%         title("Single pixel phase analysis")
%         set(gcf,'Position',[400 200 400 220])
%         legend({"Measured Intensity", "Best Fit Sine"});
%         grid on; grid minor;
%     end
% end


function phase = sineFitRestricted(x,y,plotTrue)
    fit = @(phase,x) (sin(x + phase));            % Function to fit
    fcn = @(phase) sum((fit(phase,x) - y).^2);    % Least-Squares cost function
    phase = fminsearch(fcn,0);                    % Minimise Least-Squares
    if(plotTrue)
        figure(1)
        plot(x,y,'b',  x,fit(phase,x), 'r')
        ylabel("Rescaled intensity")
        xlabel("\phi")
        title("Single pixel phase analysis")
        set(gcf,'Position',[400 200 400 220])
        legend({"Measured Intensity", "Best Fit Sine"});
        grid on; grid minor;
    end
end
%%%%%%%TEST
% To test, rename function to sineFitRestricted_
% Nperiods = 3;
% x = linspace(0, 2*pi*Nperiods, 100);
% a = -0.1; b = 0.1;r = a + (b-a).*rand(1,100);
% phaseOrig = 0.7;
% y = sin(x+phaseOrig)+r;
% 
% phase = sineFitRestricted_(x,y,true);
% display(phaseOrig)
% display(phase);

