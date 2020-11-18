function [robots, directions] = get_properties( properties, image, mask, ...
    prevRed, prevGreen, prevBlue )
    %Function retrieving the basic object properties in a frame
    

    
    %   This function, computes the direction and position of three object: a
    %   red object, a blue object and a green object.
    %
    %   INPUTS:
    %       properties - struct of Centroids, MajorAxisLength and BoundingBox
    %       image      - current frame to be processed
    %       mask       - binary version of the frame with respect to the
    %                    objects in it
    %       prevRed    - previous position of the red object
    %       prevGreen  - previous position of the green object
    %       prevBlue   - previous position of the blue object
    %
    %   OUTPUT:
    %       robots     - dictionary of robot colors (keys) and their respective 
    %                    positions 
    %       directions - list of pairs of points giving the direction of each
    %                    object
    %


    % variable initialization for later use
    directions = [];
    centroids = cat(1,properties.Centroid);
    dims = cat(1,properties.MajorAxisLength);
    imgMask = double(cat(3,mask,mask,mask));


    %------------normalization----------------

    %normalizes RGB picture and filters out the objects
    image = double(image);

    Red = image(:,:,1);
    Green = image(:,:,2);
    Blue = image(:,:,3);
    base = Red + Green + Blue;

    NormalizedRed = Red./base;
    NormalizedGreen = Green./base;
    NormalizedBlue = Blue./base;

    newimg = cat(3,NormalizedRed,NormalizedGreen,NormalizedBlue);
    newimg = double(newimg).*imgMask;
    %newimg is normalized!!


    %images for direction prediction
    tmpimg = double(image).*imgMask;
    BlackBackgroundImage = uint8(tmpimg);
    WhiteBackroundImage = BlackBackgroundImage;
    WhiteBackroundImage(~imgMask)=255;

    %dictionary of recognized objects to be returned
    robots = containers.Map;

    %initializes dictionary for final positions
    robots('red') = prevRed;
    robots('green') = prevGreen;
    robots('blue') = prevBlue;



    %-----------Objects' processing--------------------------------------------

    %iterates through the objects one by one and process them
    [propDims, ~] = size(centroids);

    for i = 1:propDims
    
        x = int16(centroids(i,1));
        y = int16(centroids(i,2));
    
        HalfWindow = floor(dims(i)/2)+1;
    
        %specifies window to crop out the object from the image
        rect = [x-HalfWindow, y-HalfWindow, 2*HalfWindow, 2*HalfWindow];
    
        %crops
        crop = imcrop(newimg,rect);
    
        [xdim, ydim, ~] = size(crop);
    
        % creates template red, blue and green image
        red = double(cat(3,ones(xdim,ydim),zeros(xdim,ydim),zeros(xdim,ydim)));
        green = double(cat(3,zeros(xdim,ydim),ones(xdim,ydim),zeros(xdim,ydim)));
        blue = double(cat(3,zeros(xdim,ydim),zeros(xdim,ydim),ones(xdim,ydim)));

    
    	%computes distance from cropped image to templates
        tmp = (crop-red).^2;
        redDist = sqrt(sum(tmp(:)));
        tmp = (crop-green).^2;
        greenDist = sqrt(sum(tmp(:)));
        tmp = (crop-blue).^2;
        blueDist = sqrt(sum(tmp(:)));
    
        %retrieves Hue values of the object to cut out only colored disk
        % (to be later used for direction prediction)
        framedObject = imcrop(WhiteBackroundImage,rect);
        framedObject = rgb2hsv(framedObject);
        framedObjectHue = framedObject(:,:,1);
    
        %assigns objects to their closest color match 
        %and retrieves binary colored disks (for direction prediction later)
        if (redDist<greenDist&&redDist<blueDist)
            robots('red') = [x,y]';
            bwBlob = (framedObjectHue>.9 | (framedObjectHue>0 & framedObjectHue<.02));
        elseif (greenDist<redDist&&greenDist<blueDist)
            robots('green') = [x,y]';
            bwBlob = (framedObjectHue>.3&framedObjectHue<.48);
        else
            robots('blue') = [x,y]';
            bwBlob = (framedObjectHue>.51&framedObjectHue<.68);
        end
    
        bwBlob = imfill(bwBlob, 'holes');
    
        %prepares image frame for retrieving a binary arrow
        crop = imcrop(WhiteBackroundImage,rect);
        crop = rgb2gray(crop);
        crop = imadjust(crop);
    
        %isolates blobs and arrows in the objects through multithresholding
        threshArrow = multithresh(crop,8);
        seg_Arrow = imquantize(crop,threshArrow);

        %eliminates noisy background
        bwArrow = seg_Arrow==1;
        bwArrow = bwArrow.*bwBlob;
        bwArrow = imfill(bwArrow, 'holes');

    
        arrowProps = regionprops(bwArrow, 'Area', 'Centroid');
        blobProps = regionprops(bwBlob, 'Area', 'Centroid');
        
        %computes centeres of blobs and arrows to predict direction
        areas = cat(1,arrowProps.Area);
        centers = cat(1,arrowProps.Centroid);
        arrowProps = horzcat(areas, centers);
        areas = cat(1,blobProps.Area);
        centers = cat(1,blobProps.Centroid);
        blobProps = horzcat(areas, centers);
    	if(not(isempty(arrowProps)) & not(isempty(blobProps)))
            arrowProps = sortrows(arrowProps, -1);
            blobProps = sortrows(blobProps, -1);
            arrowCenter = arrowProps(1,2:3);
            blobCenter = blobProps(1,2:3);
    	end

    
        %computes points for direction arrows 
        if(not(isempty(arrowProps)) & not(isempty(blobProps)))
            directions=vertcat(directions,[x+blobCenter(1)-HalfWindow,...
                y+blobCenter(2)-HalfWindow, ...
                x+arrowCenter(1)-HalfWindow, ...
                y+arrowCenter(2)-HalfWindow]);
        end
    end

    %adjusts color assignments with previous positions
    if(not(all(prevBlue==0)) & pdist([double(robots('blue'));...
            double(prevBlue)],'euclidean')>35)
        robots('blue') = prevBlue;
    end
    if(not(all(prevGreen==0)) & pdist([double(robots('green'));...
            double(prevGreen)],'euclidean')>35)
        robots('green') = prevGreen;
    end
    if(not(all(prevRed==0)) & pdist([double(robots('red'));...
            double(prevRed)],'euclidean')>35)
        robots('red') = prevRed;
    end
end
