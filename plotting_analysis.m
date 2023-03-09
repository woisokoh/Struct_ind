function plotting_analysis(x,deltas,delta0,edges1,edges2)

maxt = length(deltas)-1;

figure_setups;
subplot(2,2,1), imagesc(cell2mat(deltas(1)));
colorbar;
title('Connectivity IC');
colorbar off;


subplot(2,2,2), imagesc(cell2mat(deltas(end)));
colorbar;
title('Final Connectivity');

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
figure_setups;
subplot(2,2,1), plot(x','LineWidth',2);
title('Opinion dynamics');
ylim([-2 2]);
xlabel('Time');
ylabel('Opinion');
axis tight;
grid on;
grid minor;
%legend;

subplot(2,2,2), plot(delta_changes);
xlabel('Time');
ylabel('Changes');
title('Network changes');
axis tight;
grid on;
grid minor;

subplot(2,2,3), imagesc(degree_dist1);
title('Degree distribution');
set(gca,'YDir','normal')
colormap jetwhite;
colorbar;
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
figure_setups;
moran_out = zeros(maxt+1,1);
for i =1:maxt+1
    moran_out(i,1) = morans_i(x(:,i),deltas{1,i});
end
plot(0:maxt,moran_out);
hold on;
plot(0:maxt,movmean(moran_out,40),'-.r');
%legend('Moran''s I','Smoothed Moran''s I','Location','Southeast');
axis tight;
hold on;
xlabel('Time');
title('Moran''s I');
grid on;
grid minor;

figure_setups;
trans_out = zeros(maxt+1,1);
for i =1:maxt+1
    trans_out(i,1) = clustCoeff(deltas{1,i});
end
plot(0:maxt,trans_out);
hold on;
plot(0:maxt,movmean(trans_out,40),'-.r');
hold on;
axis tight;
xlabel('Time');
title('Transitivity');
grid on;
grid minor;

figure_setups;
temp_plot_std = std(x);
plot(0:maxt,temp_plot_std);
hold on;
plot(0:maxt,movmean(temp_plot_std,40),'-.r');
title('Opinion Stdev');
axis tight;
xlabel('time');
grid on;
grid minor;

% figure_setups;
% temp_plot_std = std(x);
% plot(0:maxt,temp_plot_std);
% hold on;
% plot(0:maxt,movmean(temp_plot_std,40),'-.r');
% title('Lag-1 Autocorrelation');
% axis tight;
% grid on;
% xlabel('time');

end