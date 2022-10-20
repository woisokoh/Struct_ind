function [x,deltas] = opi_dyn(maxt,Na,W1,W2,u,tau,d,b,beta,x0,delta0)

deltas=cell([1,maxt+1]);
x=zeros(Na,maxt+1);
deltas(1,1) = {delta0};
x(:,1) = x0;
dt = 0.05;
for t=1:maxt
    % dx/dt
    for i = 1:Na
        DaDo = 0;
        SaDo = beta(i,1) * x(i,t);
        for k = 1:Na
            if k ~= i
                del = deltas{1,t};
                DaDo = DaDo + del(i,k)*x(k,t);
            end
        end
        y = SaDo + DaDo;
        S = tanh(W1 * y);
        x(i,t+1) = x(i,t) + dt * (-d(i,1) * x(i,t) + b(i,1) + u * S);
    end

    %% ddelta/dt
%     fx = tanh(W2*abs(x(i,t) - x(i,t)'));
%     deltas(1,t+1) = {deltas{1,t} + dt * (-deltas{1,t}/tau + fx/tau)};
    deltas(1,t+1) = {delta0};
end

end
