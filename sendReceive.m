function [ status ] = sendReceive( channelNumber,frame_Array, originNode )
%SENDRECEIVE Summary of this function goes here
%   This function is mock behaviour of the send packet and ACK process
%   inside the network

% if(frame.frameType == REQFRAME)%UE request to be associated with a BS
%     if(myID == frame.recID)%if I'm the BS
%         toAddressTable(frame.sndID, frame.recID);%send to address table.
%         frameIN = FrameObj(FrameObj.ACKFRAME,frame.sndID,frame.rcvID,0);%switch ID numbers and send ACK.
%         [status frameOut] = receiveFrameUE(frameIN);
%     end
% 
% end





switch channelNumber
    case FrameObj.CHUE1BS1
        if(originNode == FrameObj.IDUE1)
            %BS receive and routing
            %check the final destination
            finalDestination = getReceiverFromArray(frame_Array);
            switch finalDestination
                case FrameObj.IDUE2
                    status = sendReceive(FrameObj.CHUE2BS1,frame_Array,FramObj.IDBS1);
                otherwise
                    error('Not valid final destination BS1');
                    % TO DO routing need to added
            end
        else
            %UE receiving
            [status,frameOut] = receiveFrameUE( frame_Array );
            switch status
                case FrameObj.CRCOK
                    %To DO routing of the ACK
                    status = sendReceive( FrameObj.CHUE2BS1,frameOut.frameArray, FrameObj.IDBS1 );
                otherwise
                   % TO DO timeout for ACK error or ACK receveid
            end
            
        end
    case FrameObj.CHUE2BS1
        if(originNode == FrameObj.IDUE2)
            %BS receive and routing
            %send to the defined channel
               %check the final destination
            finalDestination = getReceiverFromArray(frame_Array);
            switch finalDestination
                case FrameObj.IDUE1
                    status = sendReceive( FrameObj.CHUE1BS1,frame_Array, FrameObj.IDBS1 );
                otherwise
                    error('Not valid final destination BS1');
                    % TO DO routing need to added
            end
            %sendReceive( channelNumber,frame, FramObj.IDBS1 )
        else
            %UE receiving
               %UE receiving
            [status,frameOut] = receiveFrameUE( frame_Array );
            switch status
                case FrameObj.CRCOK
                    %To DO routing of the ACK
                    status = sendReceive( FrameObj.CHUE1BS1,frameOut.frameArray, FramObj.IDBS1 )
                otherwise
                   % TO DO timeout for ACK error or ACK receveid
            end
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
               %UE receiving
            [status frameOut] = receiveFrameUE( frame_Array );
            switch status
                case FrameObj.CRCOK
                    %To DO routing of the ACK
                    status = sendReceive( FrameObj.CHUE2BS1,frameOut.frameArray, FramObj.IDBS1 )
                otherwise
                   % TO DO timeout for ACK error or ACK receveid
            end
        end
    otherwise
                    error('Not channel ID valid')
                    % If this error occurs while using channel need to
                    % change
end

end

