function bbox = boundingBox(mask)
    % Get indices of 1's
    [row, col] = find(mask);

    % Get the minimum and maximum indices in each dimension
    minRow = min(row);
    maxRow = max(row);
    minCol = min(col);
    maxCol = max(col);

    % Return struct with row and column indices
    bbox.rows = minRow:maxRow;
    bbox.cols = minCol:maxCol;
end
