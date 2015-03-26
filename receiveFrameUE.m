function [ status, frameOut ] = receiveFrameUE( frame_array )
%RECEIVEFRAMEUE Summary of this function goes here
%   Detailed explanation goes here
% receate the frame from the array
receivedFrame = FrameObj(frame_array);
if(receivedFrame.frameType == FrameObj.DATAFRAME)
    
    hDetect = comm.CRCDetector([8 7 6 4 2 0]);
    [~, err] = step(hDetect, receivedFrame.data);
    if(err == 0)
        frameOut = FrameObj(FrameObj.ACKFRAME,receivedFrame.sndID,receivedFrame.rcvID,0);
        status = FrameObj.CRCOK;
    else
        frameOut = 0;
        status = FrameObj.CRCFAIL;
    end
elseif (receivedFrame.frameType == FrameObj.ACKFRAME)
    
    frameOut =0 ;
    status = FrameObj.ACKRECEIVED ;
elseif (frame.frameType == FrameObj.POLLFRAME)
    
    status = 0;
    toTimeSync(frame.data);%send time and UEID to wait to generate REQ
    
    
    frameOut = 0; %figure this out
else
        error('Not valid frame Type')
        % If this error occurs if a new channel type is used
end
end

