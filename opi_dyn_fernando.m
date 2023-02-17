function [x,deltas] = opi_dyn_fernando(maxt,Na,x0,gamma,eta,sigma)

deltas=cell([1,maxt+1]);
x=zeros(Na,maxt+1);
deltas(1,1) = {delta0};
x(:,1) = x0;
dBt = randn(Na,maxt);

for t=1:maxt
    rand_ord = randperm(Na);
    temp_delta = deltas{1,t};
    for j = 1:Na 
        % update network of agent rand_ord(i)
        % break an existing link and % add a new link
        if sum(temp_delta(rand_ord(j),:))>2
            break_indices = find(temp_delta(rand_ord(j),:)>0);
            break_link = break_indices(randperm(length(break_indices),1));
            temp_delta(rand_ord(j), break_link) = 0;
            temp_delta(break_link,rand_ord(j)) = 0;
            deltas(1,t+1)= {temp_delta};
            
            add_indices = find(temp_delta(rand_ord(j),:)==0);
            add_link = break_indices(randperm(length(add_indices),1));
            temp_delta(rand_ord(j), add_link) = 1;
            temp_delta(break_link,rand_ord(j)) = 1;
            deltas(1,t+1)= {temp_delta};
        end
        
        
        
        % x_n+1 = f(x_n)
        S = tanh(W1 * y);
        x(j,t+1) = gamma*x(j,t) +  ...
            + sigma*sqrt(dt)*dBt(j,t);
    end
    
    %% ddelta/dt
         fx = tanh(W2*abs(x(:,t) - x(:,t)'));
         %keyboard;
         deltas(1,t+1) = {deltas{1,t} + dt * (-deltas{1,t}/tau + fx/tau)};
    %deltas(1,t+1) = {delta0};
end

end
