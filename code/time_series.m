% Time series chart, YoY data on energy inflation

clear all;
close all;
clc;

res_path = '../results';

if ~exist(res_path, 'dir')
    mkdir(res_path);
end

% Load data
data = xlsread("../data/data.xlsx");
data = data(:,2:end);

set(0,'defaultfigurecolor',[1 1 1 ])

t1 = datetime("1971-01-01");
tend = datetime("2025-04-01");
T = t1:calmonths:tend;

y_lim = [-20,50];
y_lim_2 = [-20,70];
y_ticks = [-20 -10 0 10 20 30  40 50];
y_ticks_2 = [-20 -10 0 10 20 30  40 50 60 70];


% Energy inflation: France
figure(1)
plot_fra = subplot(1,1,1);
plot(T,data(:,1),'color',[0.0 0.4 0.7],'LineWidth',2);
% set(plot_fra,'XLim',x_lim);
set(plot_fra,'Ylim',y_lim,'YTick',y_ticks,'YTickLabel',y_ticks);
set(plot_fra,'FontName','times','FontSize',15);
title('Energy inflation: France','FontName','times','FontSize',15)
xtickangle(45);
set(gca,'box','off')

saveas(gcf,'../results/EI_fra','epsc')

% Energy inflation: Germany
figure(2)
plot_ger = subplot(1,1,1);
plot(T,data(:,2),'color',[0.0 0.4 0.7],'LineWidth',2);
% set(plot_ger,'XLim',x_lim1);
set(plot_ger,'Ylim',y_lim,'YTick',y_ticks,'YTickLabel',y_ticks);
set(plot_ger,'FontName','times','FontSize',15);
title('Energy inflation: Germany','FontName','times','FontSize',15)
xtickangle(45);
set(gca,'box','off')

saveas(gcf,'../results/EI_ger','epsc')

% Energy inflation: Italy
figure(3)
plot_ita = subplot(1,1,1);
plot(T,data(:,3),'color',[0.0 0.4 0.7],'LineWidth',2);
% set(plot_ita,'XLim',x_lim);
set(plot_ita,'Ylim',y_lim_2,'YTick',y_ticks_2,'YTickLabel',y_ticks_2);
set(plot_ita,'FontName','times','FontSize',15);
title('Energy inflation: Italy','FontName','times','FontSize',15)
xtickangle(45);
set(gca,'box','off')

saveas(gcf,'../results/EI_ita','epsc')

% Energy inflation: Japan
figure(4)
plot_jpn = subplot(1,1,1);
plot(T,data(:,4),'color',[0.0 0.4 0.7],'LineWidth',2);
% set(plot_jpn,'XLim',x_lim);
set(plot_jpn,'Ylim',y_lim,'YTick',y_ticks,'YTickLabel',y_ticks);
set(plot_jpn,'FontName','times','FontSize',15);
title('Energy inflation: Japan','FontName','times','FontSize',15)
xtickangle(45);
set(gca,'box','off')
saveas(gcf,'../results/EI_jpn','epsc')

% Energy inflation: UK
figure(5)
plot_uk = subplot(1,1,1);
plot(T,data(:,5),'color',[0.0 0.4 0.7],'LineWidth',2);
% set(plot_uk,'XLim',x_lim2);
set(plot_uk,'Ylim',y_lim,'YTick',y_ticks,'YTickLabel',y_ticks);
    % this sets font properties
set(plot_uk,'FontName','times','FontSize',15);
title('Energy inflation: UK','FontName','times','FontSize',15)
xtickangle(45);
set(gca,'box','off')
saveas(gcf,'../results/EI_uk','epsc')


% Energy inflation: US
figure(6)
plot_us = subplot(1,1,1);
plot(T,data(:,6),'color',[0.0 0.4 0.7],'LineWidth',2);
% set(plot_us,'XLim',x_lim);
set(plot_us,'Ylim',y_lim,'YTick',y_ticks,'YTickLabel',y_ticks);
set(plot_us,'FontName','times','FontSize',15);
title('Energy inflation: US','FontName','times','FontSize',15)
xtickangle(45);
set(gca,'box','off')
saveas(gcf,'../results/EI_us','epsc')

