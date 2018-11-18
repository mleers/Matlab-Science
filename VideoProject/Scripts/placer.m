function compImage = placer(bg,obj,gs,x,y)
    % FUNCTION: placer
    % RETURNS: 3D array with JPG image data
    % INPUTS: 
    %   bg is 3D array with background (scene) image data
    %   obj is 3D array with object image data 
    %   gs is green screen value, here only 0 or 255
    %     which is background of object image
    %   x and y are coordinates of bg at which to place
    %     top-left corner of object
    % places an image on a scene 
    

    [brows bcols bpg] = size(bg);
    [orows ocols opg] = size(obj);
 
    % create "green screen
    
    pg = zeros(brows,bcols,'uint8');
    switch gs
        case 0
            % leave black
        case 255
            % change to white
            pg = pg+255;
        otherwise
            
    end
    
    canv = cat(3,pg,pg,pg);
     
    % put object on canvas at x,y coordinates
    canv(1+y : orows+y, 1+x : ocols+x, :) = obj;
    switch gs
        % get indices of where obj is on canv
        case 0
            filter = find(canv > 0);
        case 255
            filter = find(canv < 255);
        otherwise
            
    end
    % put obj from canv onto copy of bg
    compImage = bg;
    compImage(filter) = canv(filter); 

end
