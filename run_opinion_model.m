%% set parameters
maxt = 500;
Na = 3;
W1 = 1;
W2 = 1;
u = 1;
tau = 1000;
d = ones(Na,1);
b = ones(Na,1);
beta = ones(Na,1);
sigma = 0.1;
x0 = rand(Na,1);
delta0 = ones(Na,Na) - eye(Na);
%% Run the model
x = opi_dyn(maxt,Na,W1,W2,u,tau,d,b,beta,x0,delta0,sigma);
%% Plot outputs
figure;
plot(x','LineWidth',2);
