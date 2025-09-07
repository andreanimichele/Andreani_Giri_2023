clear all;
close all;
clc;

addpath("atw_functions");

res_path = '../results';

if ~exist(res_path, 'dir')
    mkdir(res_path);
end

% Load data
data = xlsread("../data/data.xlsx");
data = data(:,2:end);

set(0,'defaultfigurecolor',[1 1 1 ]);

% t1 = datetime("1971-01-01");
% tend = datetime("2025-04-01");
% T = t1:calmonths:tend;

t1 = 1971:0.25:2025.25;

% AWT parameters
dt         = 1;
dj         = 1/50;
low_period = 2;
up_period  = 128;  
pad        = 0;
mother     = 'Morlet';
beta       = 6.0;
gamma      = 0;  
alpha       = 0.05;
% mc replications, may take long
sig_type    ='MCS'; %AR1, AR0
% n_sur       = 2000;
n_sur       = 100;
p           = 1; 
q           = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Power spectra %%%%%%%%%%%%%%%%%%%%%


%-----  Wavelet Power and corresponding p-values --------
[~,periods1_fra,coil_fra,power_fra,pv_power_fra] =...
    AWT(data(:,1),dt,dj,low_period,up_period,pad,mother,beta,gamma,sig_type,n_sur,p,q);

[~,periods1_ger,coil_ger,power_ger,pv_power_ger] =...
    AWT(data(:,2),dt,dj,low_period,up_period,pad,mother,beta,gamma,sig_type,n_sur,p,q);

[~,periods1_ita,coil_ita,power_ita,pv_power_ita] =...
    AWT(data(:,3),dt,dj,low_period,up_period,pad,mother,beta,gamma,sig_type,n_sur,p,q);

[~,periods1_jpn,coil_jpn,power_jpn,pv_power_jpn] =...
    AWT(data(:,4),dt,dj,low_period,up_period,pad,mother,beta,gamma,sig_type,n_sur,p,q);

[~,periods1_us,coil_us,power_us,pv_power_us] =...
    AWT(data(:,5),dt,dj,low_period,up_period,pad,mother,beta,gamma,sig_type,n_sur,p,q);

[~,periods1_uk,coil_uk,power_uk,pv_power_uk] =...
    AWT(data(:,6),dt,dj,low_period,up_period,pad,mother,beta,gamma,sig_type,n_sur,p,q);

%-------   Local maxima of WPS (ridges)  -----------
max_power_fra = MatrixMax(power_fra,3,.2);
max_power_ger = MatrixMax(power_ger,3,.2);
max_power_ita = MatrixMax(power_ita,3,.2);
max_power_jpn = MatrixMax(power_jpn,3,.2);
max_power_us = MatrixMax(power_us,3,.2);
max_power_uk = MatrixMax(power_uk,3,.2);

%-----  Global wavelet power spectra (GWPS) ---------
GWPS_fra = mean(power_fra,2);
GWPS_ger = mean(power_ger,2);
GWPS_ita = mean(power_ita,2);
GWPS_jpn = mean(power_jpn,2);
GWPS_us  = mean(power_us,2);
GWPS_uk  = mean(power_uk,2);


%%% ---------------------------------------------------------------------
%%% PLOT Coherency and phase differences
% 
% x_lim =  [t1(1) t1(end)];
% x_lim1 = [t1(1) t1(end)];
% x_lim2 = [t1(1) t1(end)];

y_lim = [-5,10];
y_ticks = [-5 0  5 10 ];


logcoi_fra     = log2(coil_fra);
logperiods_fra = log2(periods1_fra);
y_limCO_fra    = [min(logperiods_fra), max(logperiods_fra)];


logcoi_ger     = log2(coil_ger);
logperiods_ger = log2(periods1_ger);
y_limCO_ger    = [min(logperiods_ger), max(logperiods_ger)];


logcoi_ita     = log2(coil_ita);
logperiods_ita = log2(periods1_ita);
y_limCO_ita    = [min(logperiods_ita), max(logperiods_ita)];

logcoi_jpn     = log2(coil_jpn);
logperiods_jpn = log2(periods1_jpn);
y_limCO_jpn    = [min(logperiods_jpn), max(logperiods_jpn)];


logcoi_us     = log2(coil_us);
logperiods_us = log2(periods1_us);
y_limCO_us    = [min(logperiods_us), max(logperiods_us)];


logcoi_uk     = log2(coil_uk);
logperiods_uk = log2(periods1_uk);
y_limCO_uk    = [min(logperiods_uk), max(logperiods_uk)];

y_ticksCO_lab = [2 4 8 16 32 64 128];

y_ticksCO_lab1 = [0.2 0.3 0.6 1.3  2.7  5.3  10.7 ];

y_ticksCO = log2(y_ticksCO_lab);




%%%%%%%%%%%%%%%%%%%%%%%%%%%% Figure 1 in the main text %%%%%%%%%%%%%%%%%%%

pictEnh = 0.25; 


figure(1);
plotPower_fra = subplot(1,1,1);

    % Coherency
    imagesc(t1,logperiods_fra, (power_fra).^pictEnh);
    colormap(jet)
    %colorbar;
    caxis('manual')
    ylabel('Period (years)','FontSize',17);
    %xlabel('Time');
    % set(plotPower_fra,'XLim',x_lim);
    set(plotPower_fra,'YLim',y_limCO_fra,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse')
    %set(plotPower_fra,'YLim',y_limCO_fra,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab,'YDir','reverse')

    set(plotPower_fra,'FontName','times','FontSize',17);
    %title('Power spectrum: France','FontName','times','FontSize',17);
    hold on;
    xtickangle(45);

    % COI
    plot(t1,logcoi_fra,'w','LineWidth',2);    
    
    % Levels of signifiukce
    caxis('manual')
    contour(t1,logperiods_fra,max_power_fra,[1,1],'k-','LineWidth',2.5);  
    [cc_fra_w,hh_fra_w] = contour(t1,logperiods_fra,pv_power_fra,[alpha,alpha],...
                       'Color','w','LineWidth',1.5);   
    [cc_fra_w_2,hh_fra_w_2] = contour(t1,logperiods_fra,pv_power_fra,[0.1,0.1],...
                       'Color',[0.5, 0.5, 0.5],'LineWidth',1.5);
                   
    [cc_fra_w_3,hh_fra_w_3] = contour(t1,logperiods_fra,pv_power_fra,[0.01,0.01],...
                       'Color','g','LineWidth',1.5);               
    set(hh_fra_w,'ShowText','on');
    set(hh_fra_w_2,'ShowText','on');
    set(hh_fra_w_3,'ShowText','on');

    hold off;
    
saveas(gcf,'../results/PS_fra','epsc')
    
    
figure(2);  
 plotGWPS_fra = subplot(1,1,1);
    plot(GWPS_fra,logperiods_fra,'g','LineWidth',2)
    set(plotGWPS_fra,'YLim',y_limCO_fra,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse') 
    set(plotGWPS_fra,'FontName','arial','FontSize',17)
    %title('GWPS: France','FontSize',17)
    ylabel('Period (years)')
    xtickangle(45);
    set(gca,'box','off') 


 saveas(gcf,'../results/GWPS_fra','epsc')
   

    
    
    
    
    
 figure(3);
plotPower_ger = subplot(1,1,1);

    % Coherency
    imagesc(t1,logperiods_ger, (power_ger).^pictEnh);
    colormap(jet)
    %colorbar;
    caxis('manual')
    ylabel('Period (years)','FontSize',17);
    %xlabel('Time');
    % set(plotPower_ger,'XLim',x_lim1);
    set(plotPower_ger,'YLim',y_limCO_ger,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse')
    set(plotPower_ger,'FontName','times','FontSize',17);
    %title('Power spectrum: Germany','FontName','times','FontSize',17);
    hold on;
    xtickangle(45);

    % COI
    plot(t1,logcoi_ger,'w','LineWidth',2);    
    
    % Levels of signifiukce
    caxis('manual')
    contour(t1,logperiods_ger,max_power_ger,[1,1],'k-','LineWidth',2.5);  
    [cc_ger_w,hh_ger_w] = contour(t1,logperiods_ger,pv_power_ger,[alpha,alpha],...
                       'Color','w','LineWidth',1.5);   
    [cc_ger_w_2,hh_ger_w_2] = contour(t1,logperiods_ger,pv_power_ger,[0.1,0.1],...
                       'Color',[0.5, 0.5, 0.5],'LineWidth',1.5);
                   
    [cc_ger_w_3,hh_ger_w_3] = contour(t1,logperiods_ger,pv_power_ger,[0.01,0.01],...
                       'Color','g','LineWidth',1.5);               
    set(hh_ger_w,'ShowText','on');
    set(hh_ger_w_2,'ShowText','on');
    set(hh_ger_w_3,'ShowText','on');

    hold off;
    
saveas(gcf,'../results/PS_ger','epsc')
    
    
figure(4);  
 plotGWPS_ger = subplot(1,1,1);
    plot(GWPS_ger,logperiods_ger,'g','LineWidth',2)
    set(plotGWPS_ger,'YLim',y_limCO_ger,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse') 
    set(plotGWPS_ger,'FontName','arial','FontSize',17)
    %title('GWPS: Germany','FontSize',17)
    ylabel('Period (years)')
    xtickangle(45);
    set(gca,'box','off') 

   
saveas(gcf,'../results/GWPS_ger','epsc')


    
    
    
    
    
    figure(5);
plotPower_ita = subplot(1,1,1);

    % Coherency
    imagesc(t1,logperiods_ita, (power_ita).^pictEnh);
    colormap(jet)
    %colorbar;
    caxis('manual')
    ylabel('Period (years)','FontSize',17);
    %xlabel('Time');
    % set(plotPower_ita,'XLim',x_lim);
    set(plotPower_ita,'YLim',y_limCO_ita,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse')
    set(plotPower_ita,'FontName','times','FontSize',17);
    %title('Power spectrum: Italy','FontName','times','FontSize',17);
    hold on;
    xtickangle(45);

    % COI
    plot(t1,logcoi_ita,'w','LineWidth',2);    
    
    % Levels of signifiukce
    caxis('manual')
    contour(t1,logperiods_ita,max_power_ita,[1,1],'k-','LineWidth',2.5);  
    [cc_ita_w,hh_ita_w] = contour(t1,logperiods_ita,pv_power_ita,[alpha,alpha],...
                       'Color','w','LineWidth',1.5);   
    [cc_ita_w_2,hh_ita_w_2] = contour(t1,logperiods_ita,pv_power_ita,[0.1,0.1],...
                       'Color',[0.5, 0.5, 0.5],'LineWidth',1.5);
                   
    [cc_ita_w_3,hh_ita_w_3] = contour(t1,logperiods_ita,pv_power_ita,[0.01,0.01],...
                       'Color','g','LineWidth',1.5);               
    set(hh_ita_w,'ShowText','on');
    set(hh_ita_w_2,'ShowText','on');
    set(hh_ita_w_3,'ShowText','on');

    hold off;
    
saveas(gcf,'../results/PS_ita','epsc')
    
    
    
figure(6);  
 plotGWPS_ita = subplot(1,1,1);
    plot(GWPS_ita,logperiods_ita,'g','LineWidth',2)
    set(plotGWPS_ita,'YLim',y_limCO_ita,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse') 
    set(plotGWPS_ita,'FontName','arial','FontSize',17)
    %title('GWPS: Italy','FontSize',17)
    ylabel('Period (years)')
    xtickangle(45);
    set(gca,'box','off') 

saveas(gcf,'../results/GWPS_ita','epsc')


    
    
    
 figure(7);
plotPower_jpn = subplot(1,1,1);

    % Coherency
    imagesc(t1,logperiods_jpn, (power_jpn).^pictEnh);
    colormap(jet)
    %colorbar;
    caxis('manual')
    ylabel('Period (years)','FontSize',17);
    %xlabel('Time');
    % set(plotPower_jpn,'XLim',x_lim);
    set(plotPower_jpn,'YLim',y_limCO_jpn,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse')
    set(plotPower_jpn,'FontName','times','FontSize',17);
    %title('Power spectrum: Japan','FontName','times','FontSize',17);
    hold on;
    xtickangle(45);

    % COI
    plot(t1,logcoi_jpn,'w','LineWidth',2);    
    
    % Levels of signifiukce
    caxis('manual')
    contour(t1,logperiods_jpn,max_power_jpn,[1,1],'k-','LineWidth',2.5);  
    [cc_jpn_w,hh_jpn_w] = contour(t1,logperiods_jpn,pv_power_jpn,[alpha,alpha],...
                       'Color','w','LineWidth',1.5);   
    [cc_jpn_w_2,hh_jpn_w_2] = contour(t1,logperiods_jpn,pv_power_jpn,[0.1,0.1],...
                       'Color',[0.5, 0.5, 0.5],'LineWidth',1.5);
                   
    [cc_jpn_w_3,hh_jpn_w_3] = contour(t1,logperiods_jpn,pv_power_jpn,[0.01,0.01],...
                       'Color','g','LineWidth',1.5);               
    set(hh_jpn_w,'ShowText','on');
    set(hh_jpn_w_2,'ShowText','on');
    set(hh_jpn_w_3,'ShowText','on');

    hold off;
    
saveas(gcf,'../results/PS_jpn','epsc')
    
    
    
figure(8);  
 plotGWPS_jpn = subplot(1,1,1);
    plot(GWPS_jpn,logperiods_jpn,'g','LineWidth',2)
    set(plotGWPS_jpn,'YLim',y_limCO_jpn,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse') 
    set(plotGWPS_jpn,'FontName','arial','FontSize',17)
    %title('GWPS: Japan','FontSize',17)
    ylabel('Period (years)')
    xtickangle(45);
    set(gca,'box','off') 
   

 saveas(gcf,'../results/GWPS_jpn','epsc')
   
    
    
    
    
    
figure(9);
plotPower_us = subplot(1,1,1);

    % Coherency
    imagesc(t1,logperiods_us, (power_us).^pictEnh);
    colormap(jet)
    %colorbar;
    caxis('manual')
    ylabel('Period (years)','FontSize',17);
    %xlabel('Time');
    % set(plotPower_us,'XLim',x_lim);
    set(plotPower_us,'YLim',y_limCO_us,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse')
    set(plotPower_us,'FontName','times','FontSize',17);
    %title('Power spectrum: US','FontName','times','FontSize',17);
    hold on;
    xtickangle(45);

    % COI
    plot(t1,logcoi_us,'w','LineWidth',2);    
    
    % Levels of signifiukce
    caxis('manual')
    contour(t1,logperiods_us,max_power_us,[1,1],'k-','LineWidth',2.5);  
    [cc_us_w,hh_us_w] = contour(t1,logperiods_us,pv_power_us,[alpha,alpha],...
                       'Color','w','LineWidth',1.5);   
    [cc_us_w_2,hh_us_w_2] = contour(t1,logperiods_us,pv_power_us,[0.1,0.1],...
                       'Color',[0.5, 0.5, 0.5],'LineWidth',1.5);
                   
    [cc_us_w_3,hh_us_w_3] = contour(t1,logperiods_us,pv_power_us,[0.01,0.01],...
                       'Color','g','LineWidth',1.5);               
    set(hh_us_w,'ShowText','on');
    set(hh_us_w_2,'ShowText','on');
    set(hh_us_w_3,'ShowText','on');

    hold off;
    
saveas(gcf,'../results/PS_us','epsc')
    
    
figure(10);  
 plotGWPS_us = subplot(1,1,1);
    plot(GWPS_us,logperiods_us,'g','LineWidth',2)
    set(plotGWPS_us,'YLim',y_limCO_us,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse') 
    set(plotGWPS_us,'FontName','arial','FontSize',17)
    %title('GWPS: US','FontSize',17)
    ylabel('Period (years)')
    xtickangle(45);
    set(gca,'box','off') 
     
saveas(gcf,'../results/GWPS_us','epsc')

    
    
    
    
figure(11);
plotPower_uk = subplot(1,1,1);

    % Coherency
    imagesc(t1,logperiods_uk, (power_uk).^pictEnh);
    colormap(jet)
    %colorbar;
    caxis('manual')
    ylabel('Period (years)','FontSize',17);
    %xlabel('Time');
    % set(plotPower_uk,'XLim',x_lim2);
    set(plotPower_uk,'YLim',y_limCO_uk,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse')
    set(plotPower_uk,'FontName','times','FontSize',17);
    %title('Power spectrum: UK','FontName','times','FontSize',17);
    hold on;
    xtickangle(45);

    % COI
    plot(t1,logcoi_uk,'w','LineWidth',2);    
    
    % Levels of signifiukce
    caxis('manual')
    contour(t1,logperiods_uk,max_power_uk,[1,1],'k-','LineWidth',2.5);  
    [cc_uk_w,hh_uk_w] = contour(t1,logperiods_uk,pv_power_uk,[alpha,alpha],...
                       'Color','w','LineWidth',1.5);   
    [cc_uk_w_2,hh_uk_w_2] = contour(t1,logperiods_uk,pv_power_uk,[0.1,0.1],...
                       'Color',[0.5, 0.5, 0.5],'LineWidth',1.5);
                   
    [cc_uk_w_3,hh_uk_w_3] = contour(t1,logperiods_uk,pv_power_uk,[0.01,0.01],...
                       'Color','g','LineWidth',1.5);               
    set(hh_uk_w,'ShowText','on');
    set(hh_uk_w_2,'ShowText','on');
    set(hh_uk_w_3,'ShowText','on');

    hold off;
    
saveas(gcf,'../results/PS_uk','epsc')
    
    
figure(12);  
 plotGWPS_uk = subplot(1,1,1);
    plot(GWPS_uk,logperiods_uk,'g','LineWidth',2)
    set(plotGWPS_uk,'YLim',y_limCO_uk,'YTick',y_ticksCO,'YTickLabel',y_ticksCO_lab1,'YDir','reverse') 
    set(plotGWPS_uk,'FontName','arial','FontSize',17)
    %title('GWPS: UK','FontSize',17)
    ylabel('Period (years)')
    xtickangle(45);
    set(gca,'box','off') 

saveas(gcf,'../results/GWPS_uk','epsc')

