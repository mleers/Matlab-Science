function caIm = rotater(im,nr,gs,thr)
    % FUNCTION: rotater 
    % RETURNS: cell array with copies of rotated image
    % INPUTS:
    %   im is original 3D image array
    %   nr is number of rotations = number of images returned      
    %   gs is "green screen" 
    %   thr is threshold for setting background light gray to white, 
    %      and dark gray to black, that is
    %      background > (255-thr) is set to 255, or < thr is set to 0
    % needs improvement to handle more complex "green screening"
    %      in which an input array of [R G B] values are specified

    c = 1; % initialize cell counter for cell array
    caIm{c} = im; % start cell array with first im, NOTE { } vs. ( )
   
    while c < nr % want nr total copies
        
        c = c+1; % increment cell counter
        a = c*360/nr; % angle in degrees
        imr = imrotate(im,a,'nearest','crop'); % rotate image
        
        % set "green screen" 
        switch gs
            case 255
                filter = find(imr == 0); % indices of br elements == 0
                imr(filter) = 255; % set those elements to gs value
                % change almost white pixels to white
                filter = find(imr > 255-thr); 
                imr(filter) = 255;
            case 0
                % image has black background
                filter = find(imr < thr);
                imr(filter) = 0;
            otherwise
                disp('NO THRESHOLD FOR GS NOT 0 OR 255')
        end
        
        caIm{c} = imr; % add rotated image to new cell in cell array

    end
    