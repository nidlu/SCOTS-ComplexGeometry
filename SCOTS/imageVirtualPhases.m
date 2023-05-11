function imageVirtualPhases(aqPar)
    for phase = aqPar.phases
        % Generate and save vertical images
        output_file_path_V = [aqPar.testName '/imagesVirtual/ds_imagePhaseV' num2str(phase, '%.4f') '.png'];
        rayTrace([aqPar.testName '/postprocessing/w0.stl'], output_file_path_V, phase, 'vertical');
        
        % Generate and save horizontal images
        output_file_path_H = [aqPar.testName '/imagesVirtual/ds_imagePhaseH' num2str(phase, '%.4f') '.png'];
        rayTrace([aqPar.testName '/postprocessing/w0.stl'], output_file_path_H, phase, 'horizontal');
    end
end
