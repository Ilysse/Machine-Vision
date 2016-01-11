clear
S=-1:0.05:1;
Lambda=2;
S2=-sqrt(Lambda^2 +S.^2 -1)/Lambda;

Area=2-(1/pi)*(acos(S)-S.*sqrt(1-S.^2)+acos(S2)-S2.*sqrt(1-S2.^2));
figure
plot(S,Area)
title('dA/dO in function of s/R1')
xlabel('S=(s/R1)')
ylabel('Overlap Area divided by the area of C1')


