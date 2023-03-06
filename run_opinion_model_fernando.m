close all
%% set parameters
maxt = 1000;
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
gamma = 0.5;
% tempDelta = randn(Na,Na);
% delta0 =  tempDelta.*(ones(Na) - eye(Na));%0.05*(ones(Na,Na) - eye(Na));% - [0,0,0;0,0,0;0,0,0];zeros(Na,Na);
delta0 = full(adjacency(WattsStrogatz(Na,7,1))); % build a random small-world network for initial step.
%% Run the model
% [x,deltas] = opi_dyn(maxt,Na,W1,W2,u,tau,d,b,alpha,x0,delta0,sigma);
[x,deltas] = opi_dyn_fernando(maxt,Na,x0,gamma,eta,sigma,sigma_ND,W1,u,b,alpha,delta0);

%% Plot outputs
figure;
plot(x','LineWidth',2);
colormap jet; % colormap not working

ylim([-2 2]);

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
edges1 = 0:75; % need to adjust manually
edges2 = -2:0.01:2; % need to adjust manually
degree_dist1 = zeros(length(edges1)-1,maxt+1);
degree_dist2 = zeros(length(edges2)-1,maxt+1);
for i = 1:(maxt+1)
    h1 = histogram(sum(cell2mat(deltas(i))),edges1,'Normalization','probability');
    degree_dist1(:,i) = h1.Values';
    
    h2 = histogram(x(:,i),edges2,'Normalization','probability');
    degree_dist2(:,i) = h2.Values;
end

%%
figure;
imagesc(degree_dist1);
set(gca,'YDir','normal')
colormap(jet);
colorbar;
caxis([0 1]);
xlabel('Time');
ylabel('Edges');

%%
figure;
imagesc(degree_dist2);
set(gca,'YDir','normal')
set(gca,'ytickLabel',compose('%d',round(edges2(yticks))));
colormap(jet);
colorbar;
xlabel('Time');
ylabel('Opinion Space');

%%
global max_t x_t deltas_t
max_t = maxt;
x_t = x;
deltas_t = deltas;

slide_plot2

%%
figure;
moran_out = zeros(maxt+1,1);
for i =1:maxt+1
    moran_out(i,1) = morans_i(x(:,i),deltas{1,i});
end
plot([0:maxt]',moran_out)
xlabel('time')
ylabel('Moran''s I')

%%
figure;
trans_out = zeros(maxt+1,1);
for i =1:maxt+1
    trans_out(i,1) = clustCoeff(deltas{1,i});
end
plot([0:maxt]',trans_out)
xlabel('time')
ylabel('Transitivity')
