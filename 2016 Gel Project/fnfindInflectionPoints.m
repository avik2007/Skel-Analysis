function [num, inflections] = fnfindInflectionPoints(x,a,b)
%this function returns the number of inflection points as well as the 
%actual locations of the inflections. It takes the ppform and returns
%a list of the inflection points
firstD = fnder(x);
secondD = fnder(firstD);
crit_points = fnzeros(secondD, [a,b]);
index = 1;
list = zeros(size(crit_points)-2);
temp_num = 0;
%now we have to evaluate whether these are actually inflection points and
%not just critical points
if size(crit_points) > 3
    for index = 2:size(crit_points)-1
        plusepsilon = (crit_points(index+1)+crit_points(index))/2; 
        minusepsilon = (crit_points(index)-crit_points(index-1))/2;
        if (((plusepsilon>0) && (minusepsilon<0)) || (plusepsilon<0) && (minusepsilon>0))
            list(index) = critpoints(index);
            temp_num = temp_num + 1;
        end    
    
    end
end
num = temp_num;
inflections = list(2:temp_num);
