%
%%%%%%%%%%%%%%%%
%Examples of end to end communication 
% Course Design Project of ECE4305: Software-Defined Radio Systems and Analysis
% Developed by Team 6
%       Renato Iida rfiida@wpi.edu
%       Le Wang lewang@wpi.edu
%       Rebecca Cooper rrcooper@wpi.edu
% Cases coved by this examples
%US1 -> BS1 -> BS2 -> US3
%US3 -> BS2 -> BS1 -> US1
%US2 -> BS1 -> BS2 -> US3
%US3 -> BS2 -> BS1 -> US2
% Intra-cellular communications between UEs:
%US1 -> BS1 -> US2
%US2 -> BS1 -> US1


% Import the objects
% 
import FrameObj % 
clear *;
close all;

nFrames = 1; % number of frames that will be sent to caculate the FER of the network
errors =0;

sendersIDS = [FrameObj.IDUE1 FrameObj.IDUE3 FrameObj.IDUE2 FrameObj.IDUE3 FrameObj.IDUE1 FrameObj.IDUE2];
receiversIDS = [FrameObj.IDUE3 FrameObj.IDUE1 FrameObj.IDUE3 FrameObj.IDUE2 FrameObj.IDUE2 FrameObj.IDUE1];
nTest = length(sendersIDS);
FER = zeros(nTest,1);

% the sedn ID and receiver ID will be defined with other teams
%TDO DO Only test intercell for US2 to US2
%change the for for all cases
for indexTest = nTest:nTest
    tempString =   strcat(num2str(sendersIDS), '_', num2str(receiversIDS), '_Hello');
    frame = FrameObj(FrameObj.DATAFRAME,receiversIDS(indexTest),sendersIDS(indexTest),tempString);
    
 
    for stepFram = 1:nFrames
        switch frame.sndID
            case FrameObj.IDUE1
                status = sendReceive( FrameObj.CHUE1BS1,frame.frameArray, FrameObj.IDUE1 );
            case FrameObj.IDUE2
                status = sendReceive( FrameObj.CHUE2BS1,frame.frameArray, FrameObj.IDUE2 );
            case FrameObj.IDUE3
                status = sendReceive( FrameObj.CHUE3BS2,frame.frameArray, FrameObj.IDUE3 );
        end
    end
    
end