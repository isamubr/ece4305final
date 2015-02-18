function inputPowerTable( tempPower, BSID )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
persistent counter1;
persistent counter2;
global powerTable;
if(isempty(powerTable))
powerTable = zeros(2,21);
powerTable(1,1) = BSID1;
powerTable(2,1) = BSID2;
end
if(isempty(counter1))
    counter1 = 2;
end
if(isempty(counter2))
    counter2 = 2;
end
if BSID == powerTable(1,1)
        powerTable(1, counter1) = tempPower;
        counter1 = counter1 + 1;
        if (counter1 == 21)
            counter1 = 2;
        end
elseif BSID == powerTable(2,1)
        powerTable(2, counter2) = tempPower;
        counter2 = counter2 + 1;
        if (counter2 == 21)
            counter2 = 2;
        end
elseif error('Invalid BSID')

end
