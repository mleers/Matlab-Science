function [ fcns ] = eqns( x )
%Solves thermodynamic equations of dissolved gas
%   Detailed explanation goes here
p = 16e6; R = 8.314; a = .552; b = 3.04e-5;
Tgl = x(1);
Vl = x(2);
Vg = x(3);
fcns(1) = R*Tgl*log((Vg-b)/(Vl-b)) + a*((1/Vg)-(1/Vl)) - (p*(Vg-Vl));
fcns(2) = (R*Tgl/(Vl-b)) - a/(Vl.^2) -p;
fcns(3) = (R*Tgl/(Vg-b)) - a/(Vg.^2) -p;
end

