function [status, frameout] = toTimeSync(time_left)
status = stop;
tic ;
time inf;
t =0;
while t<time
  t = toc;
  	if decoded %if frame is decoded correctly
  		time = time_left; %make time the time left
  	end
end
[status, frameout] = decide(); %when we time out, go to decide
