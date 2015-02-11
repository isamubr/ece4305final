function [ status, frameOut ] = receiveFrameUE( frame )
%RECEIVEFRAMEUE Summary of this function goes here
%   Detailed explanation goes here
if(frame.frameType == FrameObj.FRAMEDATA)
    
    hDetect = comm.CRCDetector([8 7 6 4 2 0]);
    
    %TODO CRC verification [~, err] = step(hDetect, frame.data); 
    err = 0;
    if(err == 0)
        %create ACK packege
        %switch the role of send and received of the received package
        % the recevied ID is now the send ID
        
        frameOut = FrameObj(FrameObj.FRAMEACK,frame.sndID,frame.rcvID,0);% the payload will be zero (as long as Team 4 agrees) 
        status = FrameObj.CRCOK;
    else
        frameOut = 0;
        status = FrameObj.CRCFAIL;
    end
elseif (frame.frameType == FrameObj.FRAMEACK)
    
    frameOut =0 ;
    status = FrameObj.ACKRECEIVED ;
end

