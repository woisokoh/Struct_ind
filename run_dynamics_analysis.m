tic;
%% set parameters
maxt = 500;
Na = 300;
W1 = 0.01;
W2 = 1;
u = 1;
tau = 1; % timescale separation parameter
d = 1.5*ones(Na,1); % attention span/decay of belief
b = 0*ones(Na,1); % exogeneous forcing/influences
alpha = 0.2*ones(Na,1); % strength of self-reinforcement
sigma = 0.05; % noise parameter for opinion dynamics
sigma_ND = 0.05; % noise parameter for network dynamics
x0 = 2*randn(Na,1);
eta = 4;
eta2 = 4;
gamma = 0.5;
% tempDelta = randn(Na,Na);
% delta0 =  tempDelta.*(ones(Na) - eye(Na));%0.05*(ones(Na,Na) - eye(Na));% - [0,0,0;0,0,0;0,0,0];zeros(Na,Na);
delta0 = full(adjacency(WattsStrogatz(Na,7,1))); % build a random small-world network for initial step.
%% Run the model
% [x,deltas] = opi_dyn(maxt,Na,W1,W2,u,tau,d,b,alpha,x0,delta0,sigma);
[x,deltas] = opi_dyn_fernando_coupled(maxt,Na,x0,gamma,eta,eta2,sigma,sigma_ND,W1,u,b,alpha,delta0);
% [x,deltas] = opi_dyn_fernando(maxt,Na,x0,gamma,eta,sigma,sigma_ND,W1,u,b,alpha,delta0);
% [x,deltas] = leonardmodel(dt,N,N1,N2,theta1,theta2,K1,K2,r,T);
% [x,deltas] = opi_dyn(maxt,Na,W1,W2,u,tau,d,b,alpha,x0,delta0,sigma)
%% Plot outputs
% parameters for network plots/degree distribution calculations
edges1 = 0:75; % need to adjust manually
edges2 = -1.7:0.01:1.7; % need to adjust manually

plotting_analysis(x,deltas,delta0,edges1,edges2);

%%
toc;

