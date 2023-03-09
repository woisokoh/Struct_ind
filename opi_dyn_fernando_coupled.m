function [x,deltas] = opi_dyn_fernando(maxt,Na,x0,gamma,eta,eta2,sigma,sigma_ND,W1,u,b,alpha,delta0)

deltas=cell([1,maxt+1]);
x=zeros(Na,maxt+1);
x(:,1) = x0;
dBt = randn(Na,maxt);
deltas(1,1) = {delta0};

for t=1:maxt
    rand_ord = randperm(Na);
    temp_delta = deltas{1,t};
    
    epsilon = sigma_ND*rand();
    % calculate similarity
    Nij = (temp_delta * temp_delta.*(1-eye(Na))*(sigma_ND-2*epsilon) + epsilon ).^eta;
    sum_Nij = sum(Nij'*(sigma_ND-2*epsilon) + epsilon)';
    sij = Nij ./ sum_Nij;

    for j = 1:Na 
        % update network of agent rand_ord(i)
        % break an existing link and % add a new link
        if sum(temp_delta(rand_ord(j),:))>=2
            %keyboard;
            break_indices = find(temp_delta(rand_ord(j),:)>0);
            opinion_differences = abs(repmat(x(j,t),length(break_indices),1) - x(break_indices,t)).^eta2;%check if near zero
            cum_prob = [0,cumsum(opinion_differences/sum(opinion_differences))'];
            break_link = break_indices(find(rand()>cum_prob,1,'last'));
            
            
            % add a link - choose unconnected nodes & randomly choose 
            % based on similarity degrees
            add_indices = find(temp_delta(rand_ord(j),:)==0);
            add_indices = add_indices(add_indices ~= rand_ord(j));
            add_sij = sij(rand_ord(j),add_indices)/sum(sij(rand_ord(j),add_indices));
            cum_prob2 = [0,cumsum(add_sij)];
            r = rand;
            add_link = add_indices(find(r>cum_prob2,1,'last'));
            
            % update adjacency matrix
            if sum(temp_delta(break_link,:))>=2
                temp_delta(rand_ord(j), break_link) = 0;
                temp_delta(break_link,rand_ord(j)) = 0;
                temp_delta(rand_ord(j), add_link) = 1;
                temp_delta(add_link,rand_ord(j)) = 1;
            end

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
        x(j,t+1) = (gamma * x(j,t) + b(j,1) + u * S) ...
            + sigma*dBt(j,t);
        

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
