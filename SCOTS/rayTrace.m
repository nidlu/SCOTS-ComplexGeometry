%phaseOffset=0;
%rayTrace([aqPar.testName '/postprocessing/w0.stl'],[aqPar.testName '/postprocessing/rayTrace.png'],phaseOffset,'horizontal');

function rayTrace(stl_file_path, output_file_path, phase, orientation)
    script_name = 'rayTrace.py';
    scots_folder = 'SCOTS';
    python_script_path = fullfile(scots_folder, script_name);
    
    % Convert the paths to WSL-compatible paths
    python_script_wsl_path = strrep(python_script_path, '\', '/');
    python_script_wsl_path = strrep(python_script_wsl_path, 'C:', '/mnt/c');
    stl_file_wsl_path = strrep(stl_file_path, '\', '/');
    stl_file_wsl_path = strrep(stl_file_wsl_path, 'C:', '/mnt/c');
    output_file_wsl_path = strrep(output_file_path, '\', '/');
    output_file_wsl_path = strrep(output_file_wsl_path, 'C:', '/mnt/c');
    
    wsl_command = sprintf('wsl python3 %s %s %s %f %s', python_script_wsl_path, stl_file_wsl_path, output_file_wsl_path, phase, orientation);
    [status, result] = system(wsl_command);

    if status == 0
        disp('Python script executed successfully');
    else
        disp('Error executing the Python script');
        disp(result);
    end
end
