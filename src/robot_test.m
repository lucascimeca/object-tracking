
% Change folder_number and img_speed

folder_number = 3;
img_speed = 5;

if folder_number == 1 || folder_number == 2
    max_img_number = 200;
elseif folder_number == 3
    max_img_number = 300;
else 
    max_img_number = 0;
end

tic
imgs = loadimages(folder_number,1,max_img_number,1,0);
toc

fprintf('Images loaded\n');

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

figure;
% subplot(2,2,1);
% imshow(bk_img);
% drawnow;
fprintf('Background image created\n');

for i = 1 : img_speed : imgs_dim(4)
    img = imgs(:,:,:,i);
%     subplot(2,2,2);
%     imshow(img);
%     drawnow;

    % inverted background subtraction
    img_sub = bk_img - img;
    img_sub(:,:,1) = (img_sub(:,:,1))>20;
    img_sub(:,:,2) = (img_sub(:,:,2))>20;
    img_sub(:,:,3) = (img_sub(:,:,3))>20;
    % img_sub = (ones(480,640,3,'uint8') * 255) - img_sub;
    img_sub1 = img_sub(:,:,1) | img_sub(:,:,2) | img_sub(:,:,3);
    subplot(1,3,1);
    imshow(double(img_sub1));
    drawnow;

    % background subtraction
    img_sub = img - bk_img;
    img_sub(:,:,1) = (img_sub(:,:,1))>20;
    img_sub(:,:,2) = (img_sub(:,:,2))>20;
    img_sub(:,:,3) = (img_sub(:,:,3))>20;
    img_sub2 = img_sub(:,:,1) | img_sub(:,:,2) | img_sub(:,:,3);
    subplot(1,3,2);
    imshow(double(img_sub2));
    drawnow;
    
    img_sub3 = img_sub1 | img_sub2;
    subplot(1,3,3);
    img(:,:,1) = img(:,:,1) .* uint8(img_sub3);
    img(:,:,2) = img(:,:,2) .* uint8(img_sub3);
    img(:,:,3) = img(:,:,3) .* uint8(img_sub3);
    imshow(img);
    drawnow;
        
    
end

%ivrProcessing(folder_number,1,max_img_number,1,1)

