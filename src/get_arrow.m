%Function to do background subtraction
%Inputs: image, background and threshold for the masking
function img_arrow_object = get_arrow(img, bin_img, color, show)
    
    bin_img_inv = ~bin_img;
    img_arrow = img;
    s = size(img);

    bk_white = uint8(ones(s(1),s(2))) * 255;
    bk_white = bk_white .* uint8(bin_img_inv);
    
    if strcmp(color,'r')
        img_arrow = img(:,:,1);
    elseif strcmp(color,'g')
        img_arrow = img(:,:,2);
    elseif strcmp(color,'b')
        img_arrow = img(:,:,3);
    else
        img_arrow = img(:,:,1);        
    end
        
    img_arrow_object = bk_white + img_arrow;

    hist = dohist(img_arrow_object,0);
    hist(256,1) = 0;
    showhist(hist,0);
%     pause(0.5);
%     thres = findthresh(hist, 10, 0);
    
%     bot = 1;
%     top = 256;
%     bot_reach = 0;
%     top_reach = 0;
    
%     for i = 1 : 256
%         if bot_reach == 0
%             if hist(i:1) ~= 0
%                bot_reach = 1;
%                bot = i;
%             end
%         end
%         if top_reach == 0
%             if hist(257-i:1) ~= 0
%                top_reach = 1;
%                top = i;
%             end
%         end
%     end
    
%     for data set 1
    thres = 50;
%     for data set 2
%     thres = 100;
%     for data set 3
%     thres = 150;

    img_arrow_object = (img_arrow_object > thres);
    img_arrow_object = img_arrow_object .* bin_img;

    show = 0;
    
    if show > 0
%         subplot(2,2,4);
        figure(show);
        imshow(img_arrow_object);
        drawnow;
    end
    
end
