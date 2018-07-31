clear;
clc;
clf;
w=2000; R=1.987; T1=400; T2=600;
Xb=linspace(0,1,200);
chempota400=(R*T1)*log(1-Xb)+w*(Xb.^2);
chempota600=(R*T2)*log(1-Xb)+w*(Xb.^2);
chempotb400=(R*T1)*log(Xb)+w*((1-Xb).^2);
chempotb600=(R*T2)*log(Xb)+w*((1-Xb).^2);
figure(1)
plot(Xb,chempota400,'r',Xb,chempota600,'b');
xlabel('Xb'); ylabel('mub - Gm B');
title('Change in Chem. Pot.a @ 400K and 600k');
figure(2)
plot(Xb,chempotb400,'r',Xb,chempotb600,'b');
xlabel('Xb'); ylabel('mub - Gm B');
title('Change in Chem. Pot.b @ 400K and 600k');
