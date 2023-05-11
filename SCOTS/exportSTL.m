function mesh = exportSTL(aqPar)
    z = readmatrix([aqPar.testName '/postprocessing/w0.txt']);

    % Remove NaN values
    validIndices = ~isnan(z);
    X_valid = aqPar.mirrorX_mm_(validIndices);
    Y_valid = aqPar.mirrorY_mm_(validIndices);
    S_valid = z(validIndices);
    DT = delaunayTriangulation(X_valid, Y_valid);
    TR = triangulation(DT.ConnectivityList, DT.Points(:, 1), DT.Points(:, 2), S_valid);
    stlwrite(TR,[aqPar.testName '/postprocessing/w0.stl'])
    mesh = TR;
end