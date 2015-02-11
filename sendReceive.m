function [ status ] = sendReceive( channelNumber,frame, originNode )
%SENDRECEIVE Summary of this function goes here
%   Detailed explanation goes here







switch channelNumber
    case FrameObj.CHUE1BS1
        if(originNode == FrameObj.IDUE1)
            %BS receive and routing
            %send to the defined channel
            %sendReceive( channelNumber,frame, FramObj.IDBS1 )
        else
            %UE receiving
            [status frameOut] = receiveFrameUE( frame );
            
        end
    case FrameObj.CHUE2BS1
        if(originNode == FrameObj.IDUE1)
            %BS receive and routing
            %send to the defined channel
            %sendReceive( channelNumber,frame, FramObj.IDBS1 )
        else
            %UE receiving
            [status frameOut] = receiveFrameUE( frame );
        end
    case FrameObj.CHBS1BS2
        %to do
    case FrameObj.CHUE3BS2
        if(originNode == FrameObj.IDUE1)
            %BS receive and routing
            %send to the defined channel
            %sendReceive( channelNumber,frame, FramObj.IDBS1 )
        else
            %UE receiving
            [status frameOut] = receiveFrameUE( frame );
        end
end

end

