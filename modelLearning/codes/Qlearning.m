function Q = Qlearning(data,epsilon,alpha,traces,lambda,gamma,type)

states = unique(data(:,1));

numberOfActions = length(unique(data(:,2)));
numberOfStates = length(unique(data(:,1)));
maxNumberOfStates = 1757600;
Q = zeros(maxNumberOfStates,numberOfActions);
N = zeros(maxNumberOfStates,numberOfActions);

A = data(:,1);
B = data(:,4);
stuckStates = setdiff(B,A); % states reachable but not leavable?

iteMax = 100;
convergence = 10; threshold = 0.1;
episode = 0;
tic
while convergence > threshold && episode < iteMax && toc < 3600
    rnInd = floor(numberOfStates*rand()+1); 
    s0 = states(rnInd); % pick a random initial start
    Q0 = Q; 
    disp(['.....beginning of episode ' num2str(episode) ' initial state = ' num2str(s0)])
    ite = 1;
    reward = - 225;
    
    while reward <= 0
        
        %while ~any(objectiveState == s0) %&& ite < iteMax
        [nextstate,action0,reward] = epsilonGreedy(data,s0,epsilon,stuckStates,type); % perform epsilon-greedy search
        Qmax = maxQActions(data,Q,nextstate); % find the max of Q(s',a')
        if ite > 1 % for the first round, we just pick a random action
            
            if traces
                N(s0,action0) = N(s0,action0)+1;
                delta = reward + Qmax - Q(s0,action0);
                Q = Q + alpha*delta*N;
                N = lambda*N;
            else
                Q(s0,action0) = Q(s0,action0) + alpha*(reward+ gamma*Qmax - Q(s0,action0));
            end
            
        end
        %nextstate
        s0 = nextstate;
        ite = ite + 1;
    end
    episode = episode + 1;
    convergence = norm(Q0-Q,2);
    disp(['convergence = ' num2str(convergence)])
    
end


