function [x,deltas] = opi_dyn_fernando(maxt,Na,x0,gamma,eta,sigma,W1,u,b,alpha,delta0)

deltas=cell([1,maxt+1]);
x=zeros(Na,maxt+1);
x(:,1) = x0;
dBt = randn(Na,maxt);
deltas(1,1) = {delta0};

for t=1:maxt
    rand_ord = randperm(Na);
%     temp_delta = deltas{1,t};
    
    % calculate similarity
    Nij = (temp_delta * temp_delta.*(1-eye(Na))).^eta;
    sum_Nij = sum(Nij')';
    sij = Nij ./ sum_Nij;

    for j = 1:Na 
        % update network of agent rand_ord(i)
        % break an existing link and % add a new link
        if sum(temp_delta(rand_ord(j),:))>2
            break_indices = find(temp_delta(rand_ord(j),:)>0);
            break_link = break_indices(randperm(length(break_indices),1));
            
            % add a link - choose unconnected nodes & randomly choose 
            % based on similarity degrees
            add_indices = find(temp_delta(rand_ord(j),:)==0);
            add_indices = add_indices(add_indices ~= rand_ord(j));
            add_sij = sij(rand_ord(j),add_indices)/sum(sij(rand_ord(j),add_indices));
            cum_prob = [0,cumsum(add_sij)];
            r = rand;
            add_link = add_indices(find(r>cum_prob,1,'last'));
            
            % update adjacency matrix
            temp_delta(rand_ord(j), break_link) = 0;
            temp_delta(break_link,rand_ord(j)) = 0;
            temp_delta(rand_ord(j), add_link) = 1;
            temp_delta(add_link,rand_ord(j)) = 1;

            deltas(1,t+1)= {temp_delta};
        end
    
        DaDo = 0;
        SaDo = alpha(j,1) * x(j,t);
        for k = 1:Na
            if k ~= j
                del = temp_delta;
                DaDo = DaDo + del(j,k)*x(k,t);
            end
        end
        y = SaDo + DaDo;
        S = tanh(W1 * y);
        x(j,t+1) = x(j,t) + 1 * (-gamma * x(j,t) + b(j,1) + u * S) ...
            + sigma*sqrt(1)*dBt(j,t);
        

%         x(j,t+1) = gamma*x(j,t) +  ...
%             + sigma*sqrt(dt)*dBt(j,t);

    end
    
    %% ddelta/dt
%          fx = tanh(W2*abs(x(:,t) - x(:,t)'));
         %keyboard;
%          deltas(1,t+1) = {deltas{1,t} + dt * (-deltas{1,t}/tau + fx/tau)};
    %deltas(1,t+1) = {delta0};
end

end
