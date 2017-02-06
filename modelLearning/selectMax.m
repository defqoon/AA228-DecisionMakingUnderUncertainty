function [action,reward,nextstate] = selectMax(data,state,stuckStates,type)
% state = current state
% what action gives the max reward

index = find(data(:,1) == state); %localize the state 
possibleAction = unique(data(index,2)); % identify the possible actions
states = unique(data(:,1));
numberOfStates = length(states);
R = zeros(length(possibleAction),1); 

for i = 1 : length(possibleAction)
    tempAction = possibleAction(i);
    ind = find(data(index,2) == tempAction,1);
    R(i) = data(ind,3); %associated reward for state and action i
end

if sum(R) ~= 0  % 2 or more possible rewards
    [reward,actionind] = max(R); % identify the action that give the maximum reward
    action = possibleAction(actionind);
else
    reward = unique(R);
    actionind = floor(length(R)*rand()+1); % pick a random action
    action = possibleAction(actionind);
end

% maximum likelihood estimation
ind = find(data(:,1) == state & data(:,2) == action);

possibleNextStates = setdiff(unique(data(ind,4)),stuckStates);
% state reachable given s and action i
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

elseif type == 1 %known model, get the closest state
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

