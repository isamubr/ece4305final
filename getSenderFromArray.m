function [ senderID ] = getSenderFromArray( input_array )
%GETSENDERFROMARRAY Summary of this function goes here
%   Get the sender ID from a bit array to be used to routing
 senderID =     bi2de(input_array(1+8:2*8,1)','left-msb');
end

