% Main program
%
% This loads the pirate ship and athe seagull,then rotates the
% seagull and stores the rotated images in a cell array, then picks 
% a location in the scene and one of the rotated objects to 
% place there

% Uses user-written functions: img_loader, rotater, placer


clear all

sceneFile = 'pirate_boat.jpeg'; % loads pirate ship background
scene = img_loader(sceneFile);  

objFile = 'seagull.jpeg'; 
%  seagull.jpeg is pic of the bird
% loads seagull, stores to cell array
object = img_loader(objFile);

[snd,fs] = wavread('Seagulls.wav'); % plays seagull wav file
p = audioplayer(snd,fs); 

nr = 8; % number rotated images
gs = 0; % background greenscreen, varies with object image background
thr = 15; % threshold for background green screen

objectCellArray = rotater(object,nr,gs,thr);

n = length(objectCellArray); % get number images, should = nr
fprintf('BACK IN MAIN - %i rotated images returned \n',n)

% set initial coordinates in scene at which to place object
% x,y is row (y) and column (x) of scene on which
% top-left corner of object is placed
% c is cell number in rotated object array
x = 200;
y = 200;
c = 0;
    
% STEP THROUGH ANIMATION

for i = 1:20

    % re-iterating the motion
    x = x + 175;    % changes x coordinates 
    y = y + 200;  % creates sin motion to imitate flight
    c = c + 1;
    if c > nr
        c = 1;
    end

    % pick rotated object image in cell array to use
    object = objectCellArray{c};
    
    % calls placer, put obj on background
    im = placer(scene,object,gs,x,y);

    % displays comp image
    image(im)
    pause(0.35) % pause to slow animation so can see it happen

    % play seagulls
    play(p)
end

% functions typed to publish
type img_loader;
type rotater;
type placer;
type seagull_noise;