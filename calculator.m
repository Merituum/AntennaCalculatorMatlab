clear;clc;

f = input('Insert resonance frequency (f) [Hz]: ');
er = input('Insert dielectric constant (er): ');
h = input('Height of dielectric (h) [m]: ');
c = 3e8; 

W_patch = c / (2 * f * sqrt((er + 1) / 2));
fprintf('Width of a patch=%f\n', W_patch);

er_eff = (er + 1) / 2 + (er - 1) / 2 * (1 + 12 * (h / W_patch))^(-0.5);

deltaL = 0.412 * h * ((er_eff + 0.3) * ((W_patch / h) + 0.264)) / ...
         ((er_eff - 0.258) * ((W_patch / h) + 0.8));

L_patch = (c / (2 * f * sqrt(er_eff))) - 2 * deltaL;
fprintf('Length of a patch=%f\n', L_patch);

W_ground = W_patch*2+6*h;
L_ground = 2*L_patch+6*h;

fprintf('Width of a ground=%f\n Length of a ground=%f\n',W_ground, L_ground);