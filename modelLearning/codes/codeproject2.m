%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        SMALL DATASET                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear; clc; close all;
cd('C:\Users\Thomas\Dropbox\Dropbox\Stanford_class\CS238 - DecisonMaking\project2')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        SMALL DATASET                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
small = csvread('small.csv',1,0);
data = small;
numberOfStates = length(unique(data(:,1)));
numberOfActions = length(unique(data(:,2)));
reward = zeros(numberOfStates,numberOfActions); %4 number of max actions
ACTION = zeros(numberOfStates,numberOfStates,numberOfActions); %4 number of max actions
transitionProbs = zeros(numberOfStates,numberOfStates,numberOfActions);

%Maximum likelihood estimates of transition
for state1 = 1 : numberOfStates
    index1 = find(data(:,1) == state1); % find the states
    transitionsStates = data(index1,4); 
    states = unique(transitionsStates);% find the possible transitions states (4 max)
    actions = data(index1,2);
    for action = 1 : numberOfActions
        indAction = find(actions == action); %number of time we played the action
        countAction = length(indAction);
        i = find(data(:,1) == state1 & data(:,2) == action,1);
        reward(state1,action) = data(i,3);
        for state2 = 1 : length(states)
            index = find(transitionsStates(indAction) == states(state2));
            countState = length(index);
            transitionProbs(state1,states(state2),action) = countState/countAction;
        end
    end
end


%% value iteration
k = 0;
U0 = zeros(100,1); %expected utility is 0 for all states
policy = zeros(100,1);
convergence = 0;
Q = []; ite = 1;
while ~convergence
    for a = 1 : 4
        Q(:,a) = reward(:,a) + gamma*transitionProbs(:,:,a)*U0;
    end
    M = max(Q,[],2);
    Usave = U0;
    for i = 1 : 100
        m = max(Q(i,:));
        U0(i) = m;
        policy(i) = find(Q(i,:) == m,1);
    end
    if max(U0(:)-Usave(:)) < 0.01
        convergence = 1;
    end
    ite = ite+1;
end

csvwrite('small',policy)


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             MEDIUM DATASET  - Q LEARNING              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc
data = csvread('medium.csv',1,0);
numberOfStates = length(unique(data(:,1)));
A = data(:,1); B = data(:,4);
stuckStates = setdiff(B,A); % states reachable but not leavable?

states = unique(data(:,1));
numberOfActions = length(unique(data(:,2)));

ind = find(data(:,3) == max(data(:,3)));
objectiveState = unique(data(ind,1));
alpha = 0.1; epsilon = 0.05;
t = 0;
s0 = 0;
Q = zeros(50000,numberOfActions);
N = zeros(50000,numberOfActions);
episode = 0;

action = 1; iteMax = 10000;
convergence = 10; threshold = 1;
traces = 1; lambda = 0.1; 
local = 1; gamma = 1; type = 1; % known model
Q = Qlearning(data,epsilon,alpha,traces,lambda,gamma,type);

%% Looking at the Q matrix 
pos = 500;
vel = 100;
U = zeros(pos,vel);
for i = 0 : pos-1
    for j = 0 : vel-1
        s = 1 + i + 500*j;
        if s <= 50000
            U(i+1,j+1) = max(Q(s,:));
        end
        
    end
end
figure();
imagesc(U)

%% exploit Q matrix
[maxi,policy] = max(Q,[],2);
policy(maxi == 0) = 0;
states2 = states;
ispolicy = ones(size(policy));

for i = 1 : length(states)
    if policy(states(i)) == 0
        x = find(states2 == states(i));
        states2(x) = [];
    end
end

finalPolicy = cleanPolicy(states2,policy);
csvwrite('medium.policy',finalPolicy)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        LARGE DATASET                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

large = csvread('large.csv',1,0);
data = large;
%%
clc
maxNumberOfStates = 1757600;
states = unique(data(:,1));
rewards = unique(data(:,3)); % binary problem
numberOfStates = length(unique(data(:,1)));
numberOfActions = length(unique(data(:,2)));
gamma = 0.99;
lambda = 0.9; alpha = 0.2; epsilon = 0.1; traces = 1;
type = 0; % unknown model
Q = Qlearning(data,epsilon,alpha,traces,lambda,gamma,type);

%% EXPLOIT Q MATRIX
[maxi,policy] = max(Q,[],2);
policy(maxi == 0) = 0;
states2 = states;
ispolicy = ones(size(policy));

for i = 1 : length(states)
    if policy(states(i)) == 0
        x = find(states2 == states(i));
        states2(x) = [];
    end
end

finalPolicy = cleanPolicy(states2,policy);
csvwrite('large.policy',finalPolicy)










