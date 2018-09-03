     %Miji has to already be opened before beginning this code
%MIJ.getResultsTable;
axFijiData = struct('length',{},'V1x',{},'V1y',{},'V1z',{},'V2x',{},'V2y',{},'V2z',{},'euclidDistance',{}');
for n = 1:length(results) 
    axFijiData(n).length = results(n,2);
    axFijiData(n).V1x = results(n,3) + 1; 
    %the +1 accounts for 0 indexing of FIJI
    axFijiData(n).V1y = results(n,4) + 1;
    axFijiData(n).V1z = results(n,5) + 1;
    axFijiData(n).V2x = results(n,6) + 1;
    axFijiData(n).V2y = results(n,7) + 1;
    axFijiData(n).V2z = results(n,8) + 1;
    axFijiData(n).euclidDistance = results(n,9);
end
