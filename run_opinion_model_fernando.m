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
tic;
[x,deltas] = opi_dyn_fernando(maxt,Na,x0,gamma,eta,sigma,sigma_ND,W1,u,b,alpha,delta0);
toc;
%% Plot outputs
%% network plots/degree distribution calculations
edges1 = 0:75; % need to adjust manually
edges2 = -1.7:0.01:1.7; % need to adjust manually

figure;
subplot(2,2,1), imagesc(cell2mat(deltas(1)));
colorbar;
title('Connectivity IC');
colorbar off;

subplot(2,2,2), imagesc(cell2mat(deltas(end)));
colorbar;
title('Connectivity Final State');

subplot(2,2,3), histogram(sum(cell2mat(deltas(1))),edges1,'Normalization','probability');
title('Initial Degree Distribution');
axis tight;
grid on;

subplot(2,2,4), histogram(sum(cell2mat(deltas(end))),edges1,'Normalization','probability');
subtitle('Final Degree Distribution');
axis tight;
grid on;

%% unpack delta cell structure, comment out for speed
degree_dist1 = zeros(length(edges1)-1,maxt+1);
degree_dist2 = zeros(length(edges2)-1,maxt+1);
delta_changes = zeros(maxt,1);
for i = 1:(maxt+1)
    %h1 = histogram(sum(cell2mat(deltas(i))),edges1,'Normalization','probability');
    temp_delta = cell2mat(deltas(i));
    if i == 1
        delta_changes(i) = sum(sum(abs(temp_delta - delta0)));
    else
        delta_changes(i) = sum(sum(abs(temp_delta - temp_delta_old)));
    end
    degree_dist1(:,i) = histcounts(sum(temp_delta),edges1,'Normalization','probability');%h1.Values';
    %h2 = histogram(x(:,i),edges2,'Normalization','probability');
    degree_dist2(:,i) = histcounts(x(:,i),edges2,'Normalization','probability');%h2.Values;
    temp_delta_old = temp_delta;
end
%%
figure;
subplot(2,2,1), plot(x','LineWidth',2);
title('Opinion dynamics');
ylim([-2 2]);
xlabel('Time');
ylabel('Opinion');
grid on;
axis tight;
%legend;

subplot(2,2,2), plot(delta_changes);
xlabel('Time');
ylabel('Changes');
title('Network changes');
grid on;
axis tight;

subplot(2,2,3), imagesc(degree_dist1);
title('Degree distribution');
set(gca,'YDir','normal')
colormap jetwhite;
colorbar;
caxis([0 1]);
xlabel('Time');
ylabel('Edges');


subplot(2,2,4), imagesc(degree_dist2);
title('Opinion distribution');
set(gca,'YDir','normal')
set(gca,'ytickLabel',compose('%d',round(edges2(yticks))));
colormap jetwhite;
colorbar;
xlabel('Time');
ylabel('Opinion');

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
subplot(2,2,1), plot(0:maxt,moran_out);
axis tight;
grid on;
hold on;
xlabel('Time')
ylabel('Moran''s I')

trans_out = zeros(maxt+1,1);
for i =1:maxt+1
    trans_out(i,1) = clustCoeff(deltas{1,i});
end
subplot(2,2,2), plot(0:maxt,trans_out);
axis tight;
grid on;
xlabel('Time')
ylabel('Transitivity')

subplot(2,2,3), plot(0:maxt,movmean(moran_out,40));;
title('Smoothed Moran''s I');
axis tight;
grid on;
xlabel('time');

subplot(2,2,4), plot(0:maxt,std(x));
title('Opinion Stdev');
axis tight;
grid on;
xlabel('time');
ylabel('Stdev');


