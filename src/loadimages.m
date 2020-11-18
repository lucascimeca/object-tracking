function imgs = loadimages( path, from, to, inc, show )
%Function loading a set of images in the specified path



%   The function loads the images from the numeber specified in 'from' to
%   that specified in 'to' and 'inc' increments. The show variable allows
%   for the loaded images to be displayed if set to 1.

    i = 1;
    img_count = (floor((to-from)/inc))+1;
    imgs = zeros(480,640,3,img_count,'uint8');
     for j = from:inc:to
         imgs(:,:,:,i) = loadimage(path, j, 0);
         if show > 0
             imshow(imgs(:,:,:,i));
         end
         i = i + 1;
     end
end

