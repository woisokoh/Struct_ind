maxt = 1000;
Na = 300;
sigma = 0.05; % noise parameter for opinion dynamics
sigma_ND = 0.05; % noise parameter for network dynamics
x0 = 2*randn(Na,1);
delta0 = full(adjacency(WattsStrogatz(Na,7,1))); % build a random small-world network for initial step.

W1 = [0.01, 0.05];
u = [0.5,1,2];
b = [0*ones(Na,1),0.5*ones(Na,1)];
alpha = [0.1*ones(Na,1),0.2*ones(Na,1),0.3*ones(Na,1)];
eta = [2,4,6];
gamma = [0.1,0.5,1];

for i1 = 1:3
    for i2 = 1:3
        for i3 = 1:2
            for i4 = 1:3
                for i5 = 1:2
                    for i6 = 1:3
                        [x,deltas] = opi_dyn_fernando(maxt,Na,x0,gamma(:,i1),eta(:,i2),sigma,sigma_ND,W1(:,i3),u(:,i4),b(:,i5),alpha(:,i6),delta0);
                        f = figure('visible','off');
                        subplot(2,2,1)
                        plot(x','LineWidth',2);
                        colormap jet; % colormap not working
                        ylim([-2 2]);

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
                        subplot(2,2,2)
                        imagesc(degree_dist1);
                        set(gca,'YDir','normal')
                        colormap(jet);
                        colorbar;
                        caxis([0 1]);
                        xlabel('Time');
                        ylabel('Edges');

                        subplot(2,2,3)
                        imagesc(degree_dist2);
                        set(gca,'YDir','normal')
                        set(gca,'ytickLabel',compose('%d',round(edges2(yticks))));
                        colormap(jet);
                        colorbar;
                        xlabel('Time');
                        ylabel('Opinion Space');

                        subplot(2,2,4)
                        moran_out = zeros(maxt+1,1);
                        for i =1:maxt+1
                            moran_out(i,1) = morans_i(x(:,i),deltas{1,i});
                        end
                        plot([0:maxt]',moran_out)
                        xlabel('time')
                        ylabel('Moran''s I')

                        inputs = ['g=',num2str(gamma(:,i1)),', e=',num2str(eta(:,i2)),', W1=',num2str(W1(:,i3)),', u=',num2str(mean(u(:,i4))),', b=',num2str(mean(b(:,i5))),', a=',num2str(mean(alpha(:,i6)))];
                        file = [num2str(i1),num2str(i2),num2str(i3),num2str(i4),num2str(i5),num2str(i6),'.png'];
                        sgtitle(inputs)
                        saveas(f,file,'png')


                    end
                end
            end
        end
    end
end

