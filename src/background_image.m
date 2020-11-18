function bk_img = background_image(path, from, to, inc, show)
%Function that computes a background image.



%   The background is created by loading all images from number 'from'
%   to number 'to' with increments 'inc' in folder 'path'. The show
%   variable if set to 1 shows the final background computed  

    % load the needed images from the dataset
    imgs = loadimages(path, from, to, inc, 0);

    imgs_dim = size(imgs);

    % break the loaded images in their RGB components
    bk_r = imgs(:,:,1,:);
    bk_g = imgs(:,:,2,:);
    bk_b = imgs(:,:,3,:);
 
    bk_r = reshape(bk_r, imgs_dim(1),imgs_dim(2),imgs_dim(4));
    bk_g = reshape(bk_g, imgs_dim(1),imgs_dim(2),imgs_dim(4));
    bk_b = reshape(bk_b, imgs_dim(1),imgs_dim(2),imgs_dim(4));

    % computes median of all images for each pixel
    bk_r = median(bk_r, 3);
    bk_g = median(bk_g, 3);
    bk_b = median(bk_b, 3);
    
    %assembles for background creation
    bk_img = cat(3, bk_r,bk_g,bk_b);
    if show > 0
        figure(show);
        imagesc(bk_img);
    end
end