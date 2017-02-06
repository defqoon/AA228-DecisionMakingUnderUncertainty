function [nextstate,action,reward] = epsilonGreedy(data,state,epsilon,stuckStates,type)
%Epsilon greedy policy is a way of selecting random actions 
%with uniform distribution from a set of available actions.
% data(:,1): state
% data(:,2): action
% data(:,3): reward
% data(:,4): next state
% epsilon: probability factor


temp = rand(); % uniformly distributed between [0,1]
if temp < epsilon
    [action,reward,nextstate] = selectRandom(data,state,stuckStates,type);
    %disp('Exploration Time....')
else
    [action,reward,nextstate] = selectMax(data,state,stuckStates,type);
end




    
    
    
    
    
    

 







