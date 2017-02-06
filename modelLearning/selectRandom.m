function [action,reward,nextstate] = selectRandom(data,state,stuckStates,type)

index = find(data(:,1) == state); % locate state t
possibleAction = unique(data(index,2)); % identify the possile action

rnInd = floor(length(possibleAction)*rand()+1);
action = possibleAction(rnInd); % pick a random action

rewInd = find(data(:,1) == state & data(:,2) == action,1);
reward = data(rewInd,3);

states = unique(data(:,1));
numberOfStates = length(states);
% maximum likelihood estimation
ind = find(data(:,1) == state & data(:,2) == action);
possibleNextStates = setdiff(unique(data(ind,4)),stuckStates);

if ~isempty(possibleNextStates)
    prob = zeros(length(possibleNextStates),1);
    for i = 1 : length(possibleNextStates)
        ind2 = find(data(ind,4) == possibleNextStates(i));
        prob(i) = length(ind2);
    end
    prob = prob./sum(prob);
    
    cdf = cumsum(prob); % calculate the cdf
    r = rand(); % pick a random number
    t = cdf - r;
    j = find(t >= 0,1);
    nextstate = possibleNextStates(j);
elseif type == 1
    pnst = unique(data(ind,4));
    nextstateTemp = pnst(1);
    statesList = sort(unique(data(:,1))); % all the states available and sorted
    diff = abs(statesList - nextstateTemp);
    [~,idx] = min(diff);
    closestState = statesList(idx);
    nextstate = closestState;
elseif type == 0 %unknown model
    rnInd = floor(numberOfStates*rand()+1); 
    nextstate = states(rnInd);
end



