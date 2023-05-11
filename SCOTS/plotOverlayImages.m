function plotOverlayImages(file1, file2)
    % Step 1: Import the files
    img1 = imread(file1);
    img2 = imread(file2);

    % Step 1.1: Convert img2 to grayscale if it's an RGB image
    if ndims(img2) == 3
        img2 = rgb2gray(img2);
    end
    % Step 1.1: Convert img1 to grayscale if it's an RGB image
    if ndims(img1) == 3
        img1 = rgb2gray(img1);
    end

    % Step 2: Normalize the images to the same maximum grayscale intensity
    %         (ignoring potential high pixels)
    img1 = double(img1);
    img2 = double(img2);

    thresh1 = prctile(img1(:), 95);
    thresh2 = prctile(img2(:), 95);

    img1_norm = img1 / thresh1 * 255;
    img2_norm = img2 / thresh2 * 255;

    % Step 3: Show the images overlaid with different colors
    figure;
    img1_rgb = cat(3, img1_norm, zeros(size(img1_norm)), zeros(size(img1_norm))); % Red channel for img1
    img2_rgb = cat(3, zeros(size(img2_norm)), img2_norm, zeros(size(img2_norm))); % Green channel for img2

    overlay = uint8(img1_rgb + img2_rgb);
    
    % Create axes object
    ax = axes;
    imshow(overlay, 'Parent', ax);

    % Step 4: Add title, legend, and other improvements
    title('Overlay of Ray Trace (red) and Experiment (green)');
    
    % Create custom legend
    hold on;
    legend_bg = rectangle(ax, 'Position', [10, 10, 180, 70], 'FaceColor', 'w', 'EdgeColor', 'none');
    h1 = rectangle(ax, 'Position', [20, 20, 20, 20], 'FaceColor', 'r', 'EdgeColor', 'none');
    h2 = rectangle(ax, 'Position', [20, 50, 20, 20], 'FaceColor', 'g', 'EdgeColor', 'none');
    text(ax, 50, 30, 'Ray Trace', 'Color', 'k', 'FontSize', 14);
    text(ax, 50, 60, 'Experiment', 'Color', 'k', 'FontSize', 14);
    hold off;

    % Step 5: Save the plot as an image without a white border
    output_file_name = 'overlay_image.png';
    fig = gcf;
    
    % Remove padding around the image
    ax.Position = [0 0 1 1];
    ax.XTick = [];
    ax.YTick = [];
    ax.Box = 'off';
    
    fig.PaperPositionMode = 'auto';
    fig.InvertHardcopy = 'off';
    saveas(gcf, output_file_name);
end
