function img = loadimage(path, img_num, show)



%Function loading the image number 'img_num' from the path specified in 
%'path'. The variable 'show' allows for the loaded image to be displayed
    img = importdata(sprintf('.%s%08d.jpg', path, img_num),'jpg');
    if show > 0
        figure(show);
        imagesc(img);
    end
end