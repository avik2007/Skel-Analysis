% ------ InflectionPointFinder ------
% Avik Mondal
% last edited: 10/26/2016
% Aim:
% - find the inflection point of the vectors of my interpolated intensity
% profiles

h = 1/(Np);
X = paramLength(1, num): h : paramLength(Np,num);
firstDerivative = diff(smooth_interpa(:, num))/h;
%secondDerivative = diff(smooth_interpa(:,
cpIndex(num) = find(firstDerivative==min(firstDerivative));
% plot(paramLength(cpIndex+1),smooth_interpa(cpIndex+1, num),'x','Markersize',10,'Linewidth',2); 
paramLengthDetected(num)=paramLength(cpIndex(num));





