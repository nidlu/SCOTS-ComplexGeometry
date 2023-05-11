function [geom, aqPar] = loadParamsFromJSON(filename)
    fid = fopen(filename, 'r');
    raw = fread(fid, inf, 'uint8=>char')';
    fclose(fid);
    data = jsondecode(raw);
    geom = data.geom;
    aqPar = data.aqPar;
end
