function  do()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    

    %---------------------creates background image-------------------------------
    folder_num = 2;
    
    %initialize matrixes to create a background image
    tmp = loadimage(folder_num, 1, 0);
    [r,c,~] = size(tmp);
    bkRed = zeros(r,c,14); 
    bkGreen = zeros(r,c,14); 
    bkBlue = zeros(r,c,14); 

    i = 1;
    for j = 50:10:200
        %load images one by one
        img = loadimage(folder_num, j, 0);
    
        %extract colors and add them to the background matrixes
        bkRed(:,:,i) = img(:,:,1);
        bkGreen(:,:,i) = img(:,:,2);   
        bkBlue(:,:,i) = img(:,:,3);
    
        i = i+1;
    end

    %extract the values of the background for each color
    bkRed = median(bkRed, 3);
    bkGreen = median(bkGreen, 3);
    bkBlue = median(bkBlue, 3);

    bkgrImg = uint8(cat(3, bkRed,bkGreen,bkBlue));
    
    %Background image created!!
    
    %---------------------------------------------------------------------------



    
    i=50;
    imgs(:,:,:,i) = loadimage(folder_num, j, 0);
    current_frame = imgs(:,:,:,i);
         
    %------------------------Do background subtraction--------------------------
    %subtract background grom image
    binaryImage = backgrSub(current_frame, bkgrImg);
    %removes holes
    se = strel('disk',18);
    binaryImage = imclose(binaryImage,se);
    %---------------------------------------------------------------------------
    imshow(binaryImage)   ;
        %-------------------------Get centroids-------------------------------------
        % Get centroids of the robots.
    s = regionprops(binaryImage,'centroid');
      %Concatenate structure array containing centroids into a single matrix.
    centroids = cat(1, s.Centroid);
        %Display binary image with centroid locations superimposed.
%     
%     [Background_hsv]=round(rgb2hsv(bg));
%     [CurrentFrame_hsv]=round(rgb2hsv(image));
% 
%     % performs background subtraction given the saturation value
%     img = CurrentFrame_hsv(:,:,2);
%     bkg = Background_hsv(:,:,2);
%     BinaryImage = abs(img-bkg)>.6;
%     
%     
%     
%     
%     
%     
%     [Background_hsv]=round(rgb2hsv(bg));
%     [CurrentFrame_hsv]=round(rgb2hsv(image));
% 
%     % performs background subtraction given the saturation value
%     img = CurrentFrame_hsv(:,:,2);
%     bkg = Background_hsv(:,:,2);
%     BinaryImage = abs(img-bkg)>.6;
%     
%     
%     
% 
%     %removes holes
%     se = strel('disk',20);
%     binaryImage = imclose(binaryImage,se);
%     %---------------------------------------------------------------------------
%        
%     %-------------------------Get centroids-------------------------------------
%     % Get centroids of the robots.
%     s = regionprops(binaryImage,'centroid');
%     %Concatenate structure array containing centroids into a single matrix.
%     centroids = cat(1, s.Centroid);
%     %Display binary image with centroid locations superimposed.
%     %---------------------------------------------------------------------------
%         
%         
%         
%     % Identify individual blobs by seeing which pixels are connected to each other.
%     % Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
%     % Do connected components labeling with either bwlabel() or bwconncomp().
%     labeledImage = bwlabel(binaryImage, 8);     % Label each blob so we can make measurements of it
%     % labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... et
%          
%         
%          
%         
%     %------------------------Do object recognition------------------------------
%     %object recognition of current frame given previous frame(s)
%      
%         
%     %
%     %    TO DO
%     %
%      
%        
%     %---------------------------------------------------------------------------
% 
%     %------------------------Do direction prediction----------------------------
%     %predicts direction of robots in the image
%       
%         
%     %
%         %    TO DO
%         %
%         
%         
%         %---------------------------------------------------------------------------
%         
%         
%         
%         %prints all results on the current image (frame) to be displayed 
% 
%     if show > 0
%         imshow(current_frame);
%         hold on
%             %plots the centroids of the robots
%         plot(centroids(:,1),centroids(:,2), 'b*')
%         %plots the line from the current objects to the previous
%             %  TODO
%             %plots predicted direction of robots
%             %  TODO
%         hold off
%         drawnow;
%     end
%         
%         
%         
%         
%     i = i + 1;
end


