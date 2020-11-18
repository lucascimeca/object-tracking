function bk_img = background_image_set(img_set, from, to, inc, show)

%     if folder_number == 1 || folder_number == 2
%         max_img_number = 200;
%     elseif folder_number == 3
%         max_img_number = 300;
%     else 
%         max_img_number = 0;
%     end

    imgs = img_set(from:inc:to);

    imgs_dim = size(imgs);

    bk_r = imgs(:,:,1,:);
    bk_g = imgs(:,:,2,:);
    bk_b = imgs(:,:,3,:);

    bk_r = reshape(bk_r, imgs_dim(1),imgs_dim(2),imgs_dim(4));
    bk_g = reshape(bk_g, imgs_dim(1),imgs_dim(2),imgs_dim(4));
    bk_b = reshape(bk_b, imgs_dim(1),imgs_dim(2),imgs_dim(4));

    bk_r = median(bk_r, 3);
    bk_g = median(bk_g, 3);
    bk_b = median(bk_b, 3);

    bk_img = cat(3, bk_r,bk_g,bk_b);
    if show > 0
        figure(show);
        imagesc(bk_img);
    end
end