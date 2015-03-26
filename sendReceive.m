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
    % On channel BS1 <--> UE1
    case FrameObj.CHUE1BS1
        if(originNode == FrameObj.IDUE1)
            %BS receive and routing
            %check the final destination
            finalDestination = getReceiverFromArray(frame_Array);
            switch finalDestination
                case FrameObj.IDUE2
                    status = sendReceive(FrameObj.CHUE2BS1,frame_Array,FrameObj.IDBS1);
                
            end
        else
            %UE1 receiving
            [status,frameOut] = receiveFrameUE( frame_Array );
            switch status
                case FrameObj.CRCOK
                    %To DO routing of the ACK
                    status = sendReceive( FrameObj.CHUE1BS1,frameOut.frameArray, FrameObj.IDUE1 );
                otherwise
                   % TO DO timeout for ACK error or ACK receveid
            end
            
        end
    % On Channel BS1 <--> UE2    
    case FrameObj.CHUE2BS1
        if(originNode == FrameObj.IDUE2)
            %BS receive and routing
            %send to the defined channel
               %check the final destination
            finalDestination = getReceiverFromArray(frame_Array);
            switch finalDestination
                case FrameObj.IDUE1
                    status = sendReceive( FrameObj.CHUE1BS1,frame_Array, FrameObj.IDBS1 );
                 case FrameObj.IDUE3
                    status = sendReceive( FrameObj.CHBS1BS2,frame_Array, FrameObj.IDBS2 );
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
                    status = sendReceive( FrameObj.CHUE2BS1,frameOut.frameArray, FramObj.IDUE2 );
                otherwise
                   % TO DO timeout for ACK error or ACK receveid
            end
        end
    % On Channel BS1<--> BS2    
    case FrameObj.CHBS1BS2
        if(originNode == FrameObj.IDBS1)
            %BS2 receive and routing
            %send to the defined channel
            %check the final destination
            finalDestination = getReceiverFromArray(frame_Array);
            switch finalDestination
                case FrameObj.IDUE3
                    status = sendReceive( FrameObj.CHUE3BS2,frame_Array, FrameObj.IDBS2 );
                otherwise
                    error('Not valid final destination BS2');
                    % TO DO routing need to added
            end
            %sendReceive( channelNumber,frame, FramObj.IDBS1 )
        else
            %BS1 receiving
            finalDestination = getReceiverFromArray(frame_Array);
            switch status
                case FrameObj.IDUE1
                    status = sendReceive( FrameObj.CHUE1BS1,frameOut.frameArray, FramObj.IDBS1 );
                case FrameObj.IDUE2
                    status = sendReceive( FrameObj.CHUE2BS1,frameOut.frameArray, FramObj.IDBS1 );
                otherwise
                    error('Not valid final destination of BS1');
            end
        end
        
        
        
    % On Channel BS2 <--> UE3    
    case FrameObj.CHUE3BS2
        if(originNode == FrameObj.IDUE3)
            %BS2 receive and routing
            %send to the defined channel
            %sendReceive( channelNumber,frame, FramObj.IDBS1 )
            
            finalDestination = getReceiverFromArray(frame_Array);
            switch finalDestination
                case FrameObj.IDUE1
                    status = sendReceive(FrameObj.CHBS1BS2,frame_Array,FrameObj.IDBS2);
                case FrameObj.IDUE2
                    status = sendReceive(FrameObj.CHBS1BS2,frame_Array,FrameObj.IDBS2);    
                otherwise
                    error('Not valid final destination of BS1');
            end
        else
            %UE receiving
               %UE receiving
            [status frameOut] = receiveFrameUE( frame_Array );
            switch status
                case FrameObj.CRCOK
                    %To DO routing of the ACK
                    status = sendReceive( FrameObj.CHUE3BS2,frameOut.frameArray, FramObj.IDBS3 )
                otherwise
                   % TO DO timeout for ACK error or ACK receveid
            end
        end
    otherwise
                    error('Not valid channel ID')
                    % If this error occurs while using channel need to
                    % change
end

end

