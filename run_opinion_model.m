%% set parameters
maxt = 10000;
Na = 25;
W1 = 1;
W2 = 1;
u = 1;
tau = 1; % timescale separation parameter
d = 1.5*ones(Na,1); % attention span/decay of belief
b = 0*ones(Na,1); % exogeneous forcing/influences
alpha = 0.01*ones(Na,1); % strength of self-reinforcement
sigma = 0.0; % noise parameter
x0 = randn(Na,1);
tempDelta = randn(Na,Na);
delta0 =  tempDelta.*(ones(Na) - eye(Na));%0.05*(ones(Na,Na) - eye(Na));% - [0,0,0;0,0,0;0,0,0];zeros(Na,Na);
%% Run the model
[x,deltas] = opi_dyn(maxt,Na,W1,W2,u,tau,d,b,alpha,x0,delta0,sigma);
%% Plot outputs
figure;
plot(x','LineWidth',2);
colormap jet; % colormap not working

ylim([-2 2]);

legend;

%%

figure;
imagesc(cell2mat(deltas(1))); 
colorbar;
title('Connectivity IC');

figure;
imagesc(cell2mat(deltas(end))); 
colorbar;
title('Connectivity Final State');

