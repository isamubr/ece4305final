classdef FrameObj
    %FRAMEOBJ creates frames to be transmitted over the network
    %   Frame object to hold the heade and the payload to be used in the
    %   network
    % contastant to be used to identfy those roles inside the code
    % Channel 1  UE 1 to BS1
    %Channel 2 UE2 to BS1
    %Channel 3 BS1 to BS2
    %Channel 4 BS2 to UE3
    %ID# UE1 101
    %ID# UE2 102
    %ID# BS1 100
    %ID# BS2 200
    %ID# UE3 203
    properties (Constant)
        IDBS1 = 100;
        IDUE1 = 101;
        IDUE2 = 102;
        IDUE3 =203;
        IDBS2 = 200;
        CHUE1BS1 = 1;
        CHUE2BS1 = 2;
        CHBS1BS2 = 3;
        CHUE3BS2 = 4;
        DATAFRAME = 1;
        ACKFRAME = 2;
        CRCOK = 1;
        CRCFAIL = 2;
        ACKRECEIVED = 3;
        TIMEOUT = 4;
    end
    properties
        frameType %When sending messages we will use at least two types of frames, the Data frame, and ACK frame
        rcvID %The identification number of the destination receiver
%         nexthopID %The identification number of the next reception hop %%%may or may not be necessary
        sndID %The identification number of the sender.
%         sn %The sequence number is optional if it is necessary to deal with the situation when ACK is corrupt or lost.
        data  %data field    
    end
    properties (Dependent)
        dataSize %Indicates the length of the payload.
        CRC8 % crc-8 code verfication of the data field
        frameArray % The frame as a n*1 array
    end
    
    methods
        %function obj = FrameObj(inputframeType,inputrcvID,inputnexthopID,inputsndID,inputData)
        function obj = FrameObj(inputframeType,inputrcvID,inputsndID,inputData)
            
            %create a sequence number from 0 to 255 
%             obj.sn = uint8(randi([0 255],1,1));

            % create intial packetge with 4 all the input information
            if nargin == 4
                %test if the frame type is valid
                obj.frameType = inputframeType;
                %receiver verfication
                obj.rcvID = inputrcvID;
                %ADD if we need next hop
%                 obj.nexthopID = inputnexthopID;
                %sender verfication
                obj.sndID = inputsndID;
                obj.data = inputData;
            elseif nargin == 1
                %bitwiseInputSize = ceil(length(inputframeType)/8);
                bitwiseInput = inputframeType;
                obj.frameType=bi2de(bitwiseInput(1:8,1)','left-msb');
                obj.rcvID=bi2de(bitwiseInput(1+8:2*8,1)','left-msb');
                obj.sndID=bi2de(bitwiseInput(1+2*8:3*8,1)','left-msb');
                temp = bitwiseInput(1+3*8:5*8,1)';
                dataSizeTemp=bi2de(temp,'left-msb');
                
            else
                error('That is not a valid number of inputs')
            end
        end
        function obj = set.frameType(obj,inputframeType)
            switch inputframeType
                case FrameObj.DATAFRAME %DATA
                    obj.frameType = uint8(inputframeType);
                case FrameObj.ACKFRAME %ACK
                    obj.frameType = uint8(inputframeType);
                otherwise
                    error('Not a supported frame type')
            end
        end
        
        function obj = set.rcvID(obj,inputrcvID)
            obj.rcvID = uint8(inputrcvID);
        end
        
        %IF we need next hop
%         function obj = set.nexthopID(obj,inputnexthopID)
%             obj.nexthopID = uint8(inputnexthopID);
%         end
        
        function obj = set.sndID(obj,inputsndID)
            obj.sndID = uint8(inputsndID);
        end
        
        %data actually refers to the data and the CRC8 number ??
        function obj = set.data(obj,inputdata)
            temp_bin = reshape(dec2bin(inputdata,8)',1,[]);
            for j=1:size(temp_bin,2)
                temp_data(1,j) = str2num(temp_bin(1,j));
            end
            crcGen = comm.CRCGenerator([8 7 6 4 2 0]);
            obj.data =  step(crcGen, temp_data');
        end
        
        function value = get.dataSize(obj)
            value = length(obj.data)-8;
        end
        
        function value = get.CRC8(obj)
            [m, ~] = size(obj.data);
            for j=1:8
                value(j,1) = obj.data(m-8+j,1);
            end
        end
        
        function value = get.frameArray(obj)
            type_array  = de2bi(obj.frameType,8,'left-msb');
            rcvid_array = de2bi(obj.rcvID,8,'left-msb');
            sndid_array = de2bi(obj.sndID,8,'left-msb');
            dataSize_array = de2bi(obj.dataSize,16,'left-msb');
            
            %If we need a next hop
%             nhid_array = de2bi(obj.nexthopID,8,'left-msb');
            %If we need a sequence number
%             sn_array = de2bi(obj.sn,8,'left-msb');
            %If we need a data size indicator
%             ds_array = de2bi(obj.dataSize,8,'left-msb');

            switch obj.frameType
                case obj.DATAFRAME
                    value = [type_array'; rcvid_array'; sndid_array'; dataSize_array'; obj.data];
%                     value = [type_array'; rcvid_array'; nhid_array'; sendid_array'; sn_array'; ds_array';dataSize_array'; obj.data];
                case obj.ACKFRAME
                    value = [type_array'; rcvid_array'; sndid_array'; dataSize_array'];
%                     value = [type_array'; rcvid_array'; nhid_array'; sendid_array';dataSize_array'];
                otherwise
                    error('Not a supported frame type')
            end
        end
    end
end

