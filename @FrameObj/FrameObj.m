classdef FrameObj
    %FRAMEOBJ Summary of this class goes here
    %   Frame object to hold the heade and the payload to be used in the
    %   network
    % contastante to be used to identfy those roles inside the code
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
        FRAMEDATA = 1;
        FRAMEACK = 2;
        CRCOK = 1;
        CRCFAIL = 2;
        ACKRECEIVED = 3;
        TIMEOUT = 4;
    end
    properties
        frameType %When sending messages we will use at least two types of frames, the Data frame, and ACK frame
        rcvID %The identification number of the receiver
        sndID %The identification number of the sender.
        sn %The sequence number is optional if it is necessary to deal with the situation when ACK is corrupt or lost.
        
        data  %data field
        
    end
    properties (Dependent)
    dataSize %Indicates the length of the payload.
        CRC8 % crc-8 code verfication of the data field
    end
    methods
        function obj = FrameObj(inputframeType,inputrcvID,inputsndID,inputData)
            
            %create a sequence number from 0 to 255
            obj.sn = uint8(randi([0 255],1,1));
            % create intial packetge with 4 all the input information
            if nargin == 4
                %test if the frame type is valid
                obj.frameType = inputframeType;
                %receiver verfication
                obj.rcvID = inputrcvID;
                %sender verfication
                obj.sndID = inputsndID;
                obj.data = inputData;
            else
                obj.frameType = 1;
                %receiver verfication
                obj.rcvID = 0101;
                %sender verfication
                obj.sndID = 0102;
                obj.data = 'hello';
            end
        end
        function obj = set.frameType(obj,inputframeType)
            switch inputframeType
                case FrameObj.FRAMEDATA %DATA
                    obj.frameType = uint8(inputframeType);
                case FrameObj.FRAMEACK %ACK
                    obj.frameType = uint8(inputframeType);
                otherwise
                    error('Not a supported frame type')
            end
        end
        function obj = set.rcvID(obj,inputrcvID)
            obj.rcvID = uint8(inputrcvID);
        end
        function obj = set.sndID(obj,inputsndID)
            obj.sndID = uint8(inputsndID);
        end
        function obj = set.data(obj,inputdata)
            crcGen = comm.CRCGenerator([8 7 6 4 2 0]);
            temp = uint8(inputdata);
            obj.data =  temp % TODO replace for step(crcGen, temp);
            
        end
        function value = get.dataSize(obj)
            value = uint8(lenght(obj.data));
        end
        
        function value = get.CRC8(obj)
            value = obj.data(end);
        end
    end
end

