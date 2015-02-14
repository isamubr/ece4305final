classdef FrameObj
    %FRAMEOBJ creates frames and decodes them
    %   This class takes 2 different types of inputs, 4 inputs
    %   (Frame_Type, Receiver_ID, Sender_ID, DATA) to create the frame and
    %   1 input that is an array of bits to decode it. Data must be 
    %   included as one of the 4 inputs even if it is 0.
    
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
        frameType   %When sending messages we will use several frame types, constants for more. 
        rcvID       %The identification number of the destination receiver
        sndID       %The identification number of the sender.
        data        %The data field (cuts off after more than 235 bytes) 
    end
    properties (Dependent)
        dataSize    %Indicates the length of the payloadin bytes.
        CRC8        %CRC-8 code verfication of the data field
        frameArray  %The frame as a n*1 array
    end
    
    methods
        function obj = FrameObj(inputframeType,inputrcvID,inputsndID,inputData)
            % create intial packetge with 4 inputs
            if nargin == 4
                %test if the frame type is valid
                obj.frameType = inputframeType;
                %receiver verfication
                obj.rcvID = inputrcvID;
                %sender verfication
                obj.sndID = inputsndID;
                obj.data = inputData;
                
            %create the final packet with 1 array of bits
            elseif nargin == 1
                %bitwiseInputSize = ceil(length(inputframeType)/8);
                bitwiseInput = inputframeType;
                obj.frameType=bi2de(bitwiseInput(1:8,1)','left-msb');
                obj.rcvID=bi2de(bitwiseInput(1+8:2*8,1)','left-msb');
                obj.sndID=bi2de(bitwiseInput(1+2*8:3*8,1)','left-msb');
                temp = bitwiseInput(1+3*8:4*8,1)';
                dataSizeTemp=bi2de(temp,'left-msb'); 
               
            %incorrect number of inputs 
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
        
        function obj = set.sndID(obj,inputsndID)
            obj.sndID = uint8(inputsndID);
        end
        
        %data actually refers to the data and the CRC8 number
        function obj = set.data(obj,inputdata)
            temp_bin = reshape(dec2bin(inputdata,8)',1,[]);
            data_bits = 235*8;
            if size(temp_bin,2)>=data_bits
                for j=1:data_bits
                    temp_data(1,j) = str2num(temp_bin(1,j));
                end
            else
                for j=1:size(temp_bin,2)
                    temp_data(1,j) = str2num(temp_bin(1,j));
                end
            end
            crcGen = comm.CRCGenerator([8 7 6 4 2 0]);
            obj.data =  step(crcGen, temp_data');
        end
        
        function value = get.dataSize(obj)
            %This will always be a whole number: each symbol is a byte
            value = (length(obj.data)-8)/8;  
        end
        
        function value = get.CRC8(obj)
            %the last byte of obj.data is the CRC. It is seperated out here 
            [m, ~] = size(obj.data);
            for j=1:8
                value(j,1) = obj.data(m-8+j,1);
            end
        end
        
        function value = get.frameArray(obj)
            %we convert everything into a binary array 
            type_array  = de2bi(obj.frameType,8,'left-msb');
            rcvid_array = de2bi(obj.rcvID,8,'left-msb');
            sndid_array = de2bi(obj.sndID,8,'left-msb');
            size_array  = de2bi(obj.dataSize,8,'left-msb');
            
            %and combine them in a n*1 binary array
            switch obj.frameType
                case obj.DATAFRAME
                    value = [type_array'; rcvid_array'; sndid_array'; size_array'; obj.data];
                case obj.ACKFRAME
                    value = [type_array'; rcvid_array'; sndid_array';];
                otherwise
                    error('Not a supported frame type')
            end
        end
    end
end

