%test CRC
tempString =   'Hello';
WORD = 'hello'; 

% WORD_BINARY = dec2bin(WORD,7); % The 7 gives the number of bits
% for i=1:size(WORD_BINARY,1)
%     for j=1:size(WORD_BINARY,2)
%         WORD_OUTPUT(1,(i-1)*size(WORD_BINARY,2)+j) = str2num(WORD_BINARY(i,j));
%     end
% end

WORD = 'hello'; 

WORD_BINARY = reshape(dec2bin(WORD,7)',1,[]);
% note the <'> after the dec2bin, to transpose the matrix

for j=1:size(WORD_BINARY,2)
    WORD_OUTPUT(1,j) = str2num(WORD_BINARY(1,j));
end

 crcGen = comm.CRCGenerator([8 7 6 4 2 0]);
  
  data =  step(crcGen, WORD_OUTPUT');