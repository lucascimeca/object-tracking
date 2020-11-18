
function bin_img = backgrSub(img, bk_img, thres, show)
     
%Function performin background subtraction



%   This function computes a binary image of the objects in a frame, given
%   the frame and a background of the same.
%
%   INPUTS:
%       img        - current frame to be processed
%       bk_img     - background image of the frame to binarize
%       thres      - threshold value to be used for masking
%       show       - variable set to 1 if a window with the resulting
%                    binary image is to be displayed
%
%   OUTPUT:
%       bin_img    - dictionary of robot colors (keys) and their respective 
%                    positions
%
   
    % background subtract
    img_sub = imabsdiff(img, bk_img);
    bin_img = img_sub > thres;
    bin_img = bin_img(:,:,1) | bin_img(:,:,2) | bin_img(:,:,3);

    % remove noise from binary image
    bin_img = bwareaopen(bin_img, 300);
    se = strel('disk',5);
    bin_img = imclose(bin_img,se);
    

    if show > 0
        imshow(bin_img);
        drawnow;
    end
    
end


