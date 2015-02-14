classdef FrameObj
    %FRAMEOBJ creates frames and decodes them
    %   There are 2 input configuraions; 4 inputs mean you are using the
    %   frame requirements to create a FrameObj, 1 means you are means you
    %   are using the bits.
    
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
        
        ENCODE = 1;
        DECODE = 2;
    end
    properties
        classUse    %Identified whether we are
        frameType   %When sending messages we will use several frame types,
                    %constants for more.
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
        %This part sets the inputs to the property functions down below.
        %Those functions define the actual properties, this is where we
        %call those functions. 4 inputs mean you are using the frame
        %requirements to create a FrameObj, 1 means you are means you are
        %using the bits.
        function obj = FrameObj(inputType,inputrcvID,inputsndID,inputData)
            
            % create intial packetge with 4 inputs
            if nargin == 4
                obj.classUse = inputType;
                %test if the frame type is valid
                obj.frameType = inputType;
                obj.rcvID = inputrcvID;
                obj.sndID = inputsndID;
                obj.data = inputData;
                
                %create the final packet with 1 array of bits
            elseif nargin == 1
                %not sure if we need to do this or if this is just a
                %reminder that inputframeType is not the data that is being
                %used in this case
                bitwise = inputType;
                obj.classUse = bitwise;
                %we are actually decoding the array of bits here and then
                %passing the pretty numbers we get to the property
                %functions
                obj.frameType = bi2de(bitwise(1:8,1)','left-msb');
                obj.rcvID =     bi2de(bitwise(1+8:2*8,1)','left-msb');
                obj.sndID =     bi2de(bitwise(1+2*8:3*8,1)','left-msb');
                
                %Whether there is data or not depends on frameType
                %The location of data in the frame is dependent on dataSize
                %so we pass the unaltered input to obj.data
                obj.data = bitwise;
                
            else %incorrect number of inputs
                error('That is not a valid number of inputs')
            end
        end
        
%classUse
        %This property enables us to distingush between the two uses of the
        %class FrameObj though the length of the first (or only) input.
        %This is only used by obj.data
        function obj= set.classUse(obj,inputframeType)
            [array_or_vector,~] = size(inputframeType);
            if array_or_vector == 1
                obj.classUse = FrameObj.ENCODE;
            else
                obj.classUse = FrameObj.DECODE;
            end
        end
        
%frameType
        function obj = set.frameType(obj,inputframeType)
            %using the switch statement in this way ensures that a
            %supported data type is used
            switch inputframeType
                case FrameObj.DATAFRAME %DATA
                    obj.frameType = uint8(inputframeType);
                case FrameObj.ACKFRAME %ACK
                    obj.frameType = uint8(inputframeType);
                otherwise
                    error('Not a supported frame type for FrameObj')
                    % if you get this error using a legitimate frame type
                    % that should exist plese add an addiional case
                    % statement for that frame type
            end
        end
        
%rcvID
        function obj = set.rcvID(obj,inputrcvID)
            obj.rcvID = uint8(inputrcvID);
        end
        
%sndID
        function obj = set.sndID(obj,inputsndID)
            obj.sndID = uint8(inputsndID);
        end
        
%data
        %frameType dependent --returns '' if ACK
        %classUse dependent
        %data actually refers to the data and the CRC8 number
        function obj = set.data(obj,datainput)
            switch obj.frameType
                case FrameObj.DATAFRAME %DATA
                    if obj.classUse == FrameObj.ENCODE;
                        %This converts the datainput into an array of bits
                        temp_bin = reshape(dec2bin(datainput,8)',1,[]);
                        data_bits = 235*8;
                        if size(temp_bin,2)>=data_bits
                            %Define the length of temp_data for speed
                            temp_data = zeros(1,data_bits);
                            for j=1:data_bits
                                temp_data(1,j) = str2num(temp_bin(1,j));
                            end
                        else
                            %Define the length of temp_data for speed
                            temp_data = zeros(1,size(temp_bin,2));
                            for j=1:size(temp_bin,2)
                                temp_data(1,j) = str2num(temp_bin(1,j));
                            end
                        end
                        crcGen = comm.CRCGenerator([8 7 6 4 2 0]);
                        % calculates the CRC and adds it to the end of data
                        obj.data =  step(crcGen, temp_data');
                    elseif obj.classUse == FrameObj.DECODE;
                        %this seperates the data from the rest of the array
                        %using the data size
                        %first seperate datasize and convert to decimal
                        Temp =  bi2de(datainput(1+3*8:4*8,1)','left-msb');
                        ds = double(Temp+1); %add 1 for CRC,cast to double
                        ds = (ds*8);          %convert from bytes to bits
                        %seperate data using length(ds) & start(index 33)
                        obj.data = double(datainput(4*8+1:(4*8)+ds,1));
                    end
                case FrameObj.ACKFRAME %ACK
                    obj.data = '';
                otherwise
                    error('Not a supported frame type for data')
                    % if you get this error using a legitimate frame type
                    % that should exist plese add an addiional elseif for
                    % that frame type.
                    % if there is no data for this frame type copy ACKFRAME
                    % if there is str data copy DATAFRAME
                    % A diferent type of data will require a different case
            end
        end
        
%dataSize
        %frameType dependent --returns 0 if ACK
        function value = get.dataSize(obj)
            switch obj.frameType
                case FrameObj.DATAFRAME %DATA
                    %This will always be a whole number
                    value = (length(obj.data)-8)/8;
                case FrameObj.ACKFRAME %ACK
                    value = 0;
                otherwise
                    error('Not a supported frame type for dataSize')
                    % if you get this error using a legitimate frame type
                    % that should exist plese add an addiional elseif for
                    % that frame type.
                    % if there is no data for this frame type copy ACKFRAME
                    % if there is str data copy DATAFRAME
                    % A diferent type of data will require a different case
            end
        end
        
%CRC8
        %frameType dependent --returns '' if ACK
        function value = get.CRC8(obj)
            switch obj.frameType
                case FrameObj.DATAFRAME %DATA
                    %The last byte of obj.data is the CRC. It is seperated
                    %from the data here
                    [m, ~] = size(obj.data);
                    value =zeros(8,1);      %Define value for speed
                    for j=1:8
                        value(j,1) = obj.data(m-8+j,1);
                    end
                case FrameObj.ACKFRAME %ACK
                    value = '';
                otherwise
                    error('Not a supported frame type for dataSize')
                    % if you get this error using a legitimate frame type
                    % that should exist plese add an addiional elseif for
                    % that frame type.
                    % if there is no data for this frame type copy ACKFRAME
                    % if there is data copy DATAFRAME
            end
        end
        
%frameArray
        %frameType dependentACKFRAME  = type, rcvID, sndID
        %                   DATAFRAME = type, rcvID, sndID, size, data, CRC
        function value = get.frameArray(obj)
            %we convert everything into a binary array
            type_array  = de2bi(obj.frameType,8,'left-msb');
            rcvid_array = de2bi(obj.rcvID,8,'left-msb');
            sndid_array = de2bi(obj.sndID,8,'left-msb');
            size_array  = de2bi(obj.dataSize,8,'left-msb');
            
            %and combine them in a n*1 binary array
            switch obj.frameType
                case obj.DATAFRAME
                    value = [type_array'; rcvid_array'; sndid_array'; 
                             size_array'; obj.data];
                case obj.ACKFRAME
                    value = [type_array'; rcvid_array'; sndid_array';];
                otherwise
                    error('Not a supported frame type for frameArray')
                    % if you get this error using a legitimate frame type
                    % that should exist plese add an addiional elseif for
                    % that frame type.
                    % if there is no data for this frame type copy ACKFRAME
                    % if there is data copy DATAFRAME
                    
            end
        end
    end
end

