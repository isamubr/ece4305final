function decide()
[row1 col1 v1] = find(powerTable(1, 2:end));
[row2 col2 v2] = find(powerTable(2, 2:end));

avg1 = mean(v1);
avg2 = mean(v2);

if(avg1 >= avg2) %BS1 is stronger
sendReceive(FrameObj(FrameObj.REQFRAME, powerTable(1,1), UEID, 0));
elseif(avg2 > avg1) %BS2 is stronger
sendReceive(FrameObj(FrameObj.REQFRAME, powerTable(2,1), UEID, 0));
end
