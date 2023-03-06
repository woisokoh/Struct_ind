function out = morans_i(x,adj)
%% MORANS_I(x,adj)
%
%% INPUTS
%
% x : opinion state (n by 1 format)
% adj : adjacency matrix (n by n format)
% 
%% OUTPUTS
% 
% out : Moran's I (0 - random; 1 - assortative; -1 - dissortative mixing)
% 
Ax = adj .* x;
mu = sum(Ax(:))/sum(adj(:));
n = length(adj);
top = 0;
bot = 0;
for i =1:n
    for j = 1:n
        top = top + adj(i,j) * (x(i,1)- mu) * (x(j,1)- mu);
    end
    bot = bot + (x(i,1)- mu) * (x(i,1)- mu);
end

out = n * top / sum(adj(:)) / bot;

end