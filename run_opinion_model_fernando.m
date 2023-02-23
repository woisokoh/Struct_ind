%% set parameters
maxt = 500;
Na = 300;
W1 = 0.01;
W2 = 1;
u = 1;
tau = 1; % timescale separation parameter
d = 1.5*ones(Na,1); % attention span/decay of belief
b = 0*ones(Na,1); % exogeneous forcing/influences
alpha = 0.01*ones(Na,1); % strength of self-reinforcement
sigma = 0.0; % noise parameter
x0 = 2*randn(Na,1);
eta = 4;
gamma = 0.5;
% tempDelta = randn(Na,Na);
% delta0 =  tempDelta.*(ones(Na) - eye(Na));%0.05*(ones(Na,Na) - eye(Na));% - [0,0,0;0,0,0;0,0,0];zeros(Na,Na);
delta0 = full(adjacency(WattsStrogatz(Na,7,1))); % build a random small-world network for initial step.
%% Run the model
% [x,deltas] = opi_dyn(maxt,Na,W1,W2,u,tau,d,b,alpha,x0,delta0,sigma);
[x,deltas] = opi_dyn_fernando(maxt,Na,x0,gamma,eta,sigma,W1,u,b,alpha,delta0);

%% Plot outputs
figure;
plot(x','LineWidth',2);
colormap jet; % colormap not working

% ylim([-2 2]);

%legend;

%%

figure;
imagesc(cell2mat(deltas(1))); 
colorbar;
title('Connectivity IC');

figure;
imagesc(cell2mat(deltas(end))); 
colorbar;
title('Connectivity Final State');

figure;
plot(graph(deltas{1,end}))
title('Final Connectivity Graph');

figure; 
histogram(sum(cell2mat(deltas(1))));
title('Initial Degree Distribution');

figure; 
histogram(sum(cell2mat(deltas(end))));
title('Final Degree Distribution');

%% unpack delta cell structure, comment out for speed
edges = 0:75; % need to adjust manually
degree_dist = zeros(length(edges)-1,maxt+1);
for i = 1:(maxt+1)
    h = histogram(sum(cell2mat(deltas(i))),edges,'Normalization','probability');
    degree_dist(:,i) = h.Values';
end
figure;
imagesc(degree_dist);
set(gca,'YDir','normal')
colormap(jetwhite);
colorbar;
caxis([0 1]);
xlabel('Time');
ylabel('Edges');



