function toTimeSync(time_data)
% time_data is formatted to be in seconds.
time_sec = mod(time_data, 60); %get time in seconds
time_min = floor(time_data/60); %get time in minutes
t = clock;
while ((t(5) != time_min) & (round(t(6)) != time_sec))% while the minutes and seconds are not equal to the time wanted
t = clock; %update the clock
end
frameout = decide(); %when we time out, go to decide
