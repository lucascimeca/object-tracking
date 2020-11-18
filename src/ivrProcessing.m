function  ivrProcessing( path, img_count, show )
%Function which traces a path of three (red, blue and green) moving objects.



%   This function taks a path to a dataset containg consecutive frames of
%   video feedback, loads a part to create a background image and uses the
%   background image to locate three objects in each frame. Each object is
%   recognized as red, blue or green and a path is traced connecting the
%   various positions the robots take through their motion. Moreover, a
%   direction for each of the object is shown. The direction is computed to
%   be the one which the robots are facing at any given time.
%
%    INPUTS:
%       path      - path to the folder containing the frames to be processed
%       img_count - number of frames to process in the folder
%       show      - set to 1 if the results are to be shown in a window


%---------------------creates background image-------------------------------

%   Create a background image for the dataset
    tic  
    bkgrImg = background_image(path, 50, 200, 10, 0);
    toc
%   Background image created!!

%--------------------------------------------------------------------------

%-----------initialize variables for image processing --------------------- 

    imgs = zeros(480,640,3,img_count,'uint8');    
    thres = 20;
    blob_size = 300;
   
    % variables holding the paths of the robots throughout the frames
    red_centroids = [];
    green_centroids = [];
    blue_centroids = [];
    
    %belief positions (to be updated continuously thoughout the program)
    redPosition = [0,0];
    bluePosition = [0,0];
    greenPosition = [0,0];
      
    
%------------------------------------------------------------------------%   
%-------------------FRAME PROCESSING BEGINS------------------------------%
%---------load one frame at each iteration of the for loop---------------%



    for j = 1:img_count
        current_frame = loadimage(path, j, 0);
         
%------------------------Do background subtraction-------------------------

        %subtract background grom image
        binaryImage = backgrSub(current_frame, bkgrImg, thres, 0); 

        
%-----------------------Do object recognition------------------------------
%--------------------------------&-----------------------------------------
%-----------------------Direction prediction-------------------------------

%object recognition of objects in current frame with respect to the objects
%to the previous

        %Get the properties of the robots(centroids and blob's widths into 
        %a struct)

        properties = regionprops(binaryImage,'Centroid', 'MajorAxisLength');  
           
        %retrieve information on object identity, position and direction
        %from the frame.
        [robot, directions] = get_properties(properties, current_frame, binaryImage, ...
            redPosition, greenPosition, bluePosition);
        
        [~, id] = lastwarn;
        warning('off', id)
  
        % adds to arrays of centroids to build up current path
        if not(isnan(robot('red'))) & not(all(robot('red')==0))
            red_centroids = horzcat(red_centroids, robot('red'));
            redPosition = robot('red');
        end
        if not(isnan(robot('green'))) & not(all(robot('green')==0))
            green_centroids = horzcat(green_centroids, robot('green'));
            greenPosition = robot('green');
        end
        if not(isnan(robot('blue'))) & not(all(robot('blue')==0))
            blue_centroids = horzcat(blue_centroids, robot('blue'));
            bluePosition = robot('blue');
        end
        
%--------------------------------------------------------------------------

        %prints all results on the current image (frame) to be displayed 
        if show > 0 || j == img_count
            figure(1)
            imshow(current_frame);
            hold on
            %plots the centroids of the robots
            plot(redPosition(1), redPosition(2), 'r*')
            plot(bluePosition(1), bluePosition(2), 'b*')
            plot(greenPosition(1), greenPosition(2), 'g*')
     
            %plots the paths of the robots
            if(not(isempty(red_centroids)))
                r = plot(red_centroids(1,:),red_centroids(2,:), '-g','LineWidth',4);
                set(r,'Color','red');
            end
            
            if(not(isempty(blue_centroids)))
                b = plot(blue_centroids(1,:),blue_centroids(2,:), '-g','LineWidth',4);
                set(b,'Color','blue');
            end
            if(not(isempty(green_centroids)))
                g = plot(green_centroids(1,:),green_centroids(2,:), '-g','LineWidth',4);
                set(g,'Color','green');
            end
            
            %plots predicted direction of robots
            [dims,~] = size(directions);
            for i = 1:dims
                p1 = directions(i,1:2);
                p2 = directions(i,3:4);
                diff = p2-p1;
                quiver(p1(1),p1(2),diff(1), diff(2),'AutoScaleFactor',20,'color',[0 0 0],'linewidth',3, 'MaxHeadSize', .5);
            end
            
            hold off
            drawnow;
        end
       
    end

end

