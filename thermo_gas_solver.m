clear all
clc
T = 600; V1= 48.98438*10^-6; V2= 295.562*10^-6;
guess = [T, V1, V2];
results = fsolve(@eqns, guess)
