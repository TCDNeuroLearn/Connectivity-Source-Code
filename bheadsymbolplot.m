plotR=100;
plottheta=0:0.001:(2.01*pi);
Yoffset=0;
plot(plotR.*cos(plottheta),plotR.*sin(plottheta)-Yoffset,'Color','k','LineWidth',2);
hold on

eartheta=(0.4*pi):0.001:(1.6*pi);
plot(-plotR+cos(eartheta)*10,25.*sin(eartheta)-Yoffset,'Color','k','LineWidth',2);
plot(plotR-cos(eartheta)*10,25.*sin(eartheta)-Yoffset,'Color','k','LineWidth',2);
plot(plotR.*cos(2*pi*(0.25+[-0.015 0 0.015])),plotR.*sin(2*pi*(0.25+[-0.015 0 0.015]))-Yoffset+[0 15 0],'Color','k','LineWidth',2);
xlim(115.*[-1 1]);
ylim(115.*[-1 1]);  
set(gca, 'XTick', []);
set(gca, 'YTick', []);