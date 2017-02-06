function finalPolicy = cleanPolicy(states,policy)
% filling the missing values by interpolation

finalPolicy = policy;
for i = 1 : length(states)
    
    if i == 1
        finalPolicy(1:states(i)) = policy(states(i)); % fill the beginning
    else
        if policy(states(i)) == policy(states(i-1))
            finalPolicy(states(i-1):states(i)) = policy(states(i-1));
        elseif states(i)-states(i-1) > 1
            threshold = round((states(i)-states(i-1))/2);
            finalPolicy(states(i-1):states(i-1)+threshold) = policy(states(i-1));
            finalPolicy(states(i-1)+threshold+1:states(i)) = policy(states(i));
        end
    end
end
finalPolicy(states(end):end) = policy(states(end)); 