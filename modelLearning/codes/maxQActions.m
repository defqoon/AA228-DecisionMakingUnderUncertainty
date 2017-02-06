function Qmax = maxQActions(data,Q,nextstate)
% data
% Q 

index = find(data(:,1) == nextstate); % find the rows
possibleActions = unique(data(index,2));
Qmax = max(Q(nextstate,possibleActions));