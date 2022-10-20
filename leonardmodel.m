function a_cell = leonardmodel(dt,N,N1,N2,theta1,theta2,K1,K2,r,T)
    % parameters from Leonard PNAS paper
    % N = 30, N1 = 5, N2 = 5, theta1 = 0, theta2 = pi()/2
    % K1 = 2, K2 = 10, r = 0.6 from Fig. 3,
    % dt = 0.1, T = 5 from my selection
    % output -- a at each time step
    theta = zeros(T,N);
    % initial theta values from the paper SI material
    init_theta = [linspace(-78.5/180*pi(),-58.5/180*pi(),5), linspace(71.5/180*pi(),91.5/180*pi(),5),linspace(-53.5/180*pi(),66.5/180*pi(),20)];
    theta(1,:) = init_theta;
    thetas = [theta1*ones(1,N1),theta2*ones(1,N2)];
    % get a range of uniform distribution from mean and std
    syms x, rg = double(solve((x-0.2)^2==0.03));
    % inital a_lj matrix from the uniform distribution
    a = unifrnd(rg(1),rg(2),[N,N]);
    % store a at each time step
    a_cell = {};
    a_cell{T,1} = [];
    a_cell{1,1} = a;
    
    for t = 1:(T-1)
        % former part of the theta equations
        dtheta_p1 = [sin(thetas - theta(t,1:N1+N2)),zeros(1,N-N1-N2)];
        % latter part of the theta equations
        dtheta_p2 = K1 / N * sum(a * sin(theta(t,:) - theta(t,:)'));
        % Euler method (x(t+1)=x(t)+dx)
        theta(t+1,:) = theta(t,:) + dt * (dtheta_p1 + dtheta_p2);
        da = K2 .* a .* (1 - a) .* (abs(cos(.5 * (theta(t,:) - theta(t,:)')) - r));
        a = a + dt * da;
        a_cell{t+1,1} = a;
    end
end