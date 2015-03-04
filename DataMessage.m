function message =  DataMessage( datacrc )
%Prints the message found in the data field of the frame array
%   the input should be _received_frame_.data  from the class FrameObj
%   there is no output but it does print the message


% Chop off the CRC
databits = datacrc(1:end-8);
% isolate the bytes
databytes = reshape(databits',  8, []);
% convert each byte into the decimal ascii codes
dataascii = bi2de(databytes','left-msb');
% convert to characters 
message = char(dataascii'); 


end

