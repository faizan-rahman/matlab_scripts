function dir = dir_calculator(o,h_predict,v_predict)
if abs(o - h_predict) + 3 < abs(o - v_predict)
    dir = 'H';
else
    dir = 'V';
end
dir = char(dir);