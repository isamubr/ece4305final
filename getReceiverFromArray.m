function [ recID ] = getReceiverFromArray( input_array )
%GETRECEIVERFROMARRAY Summary of this function goes here
%   Detailed explanation goes here
 recID =     bi2de(input_array(1+8:2*8,1)','left-msb');

end

