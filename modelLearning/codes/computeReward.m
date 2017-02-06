function R = computeReward(T,R)

s = size(T);
for i = 1 : s(1) % all states
    actions = find(T(i,:) ~= 0); % number of possible action
    for j = 1 : length(actions)
        R(
    end
end