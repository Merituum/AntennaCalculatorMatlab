clear; clc;

% Input parameters
f = input('Insert resonance frequency (f) [Hz]: ');
er = input('Insert dielectric constant (er): ');
h = input('Height of dielectric (h) [m]: ');
w_line = input('Width of microstrip line (w_line) [m]: ');
fprintf("Select 1 for antenna Patch antenna\n");
fprinf("Select 2 for Microstrip Patch Antenna");
c = 3e8;
% f=3.4*10^9;
% er=4.3;
% h=0.0008;
% w=0.002;
% Calculate patch dimensions
W_patch = c / (2 * f * sqrt((er + 1) / 2));
fprintf('Width of a patch = %f m\n', W_patch);

er_eff = (er + 1) / 2 + (er - 1) / 2 * (1 + 12 * (h / W_patch))^(-0.5);

deltaL = 0.412 * h * ((er_eff + 0.3) * ((W_patch / h) + 0.264)) / ...
         ((er_eff - 0.258) * ((W_patch / h) + 0.8));

L_patch = (c / (2 * f * sqrt(er_eff))) - 2 * deltaL;
fprintf('Length of a patch = %f m\n', L_patch);

% Calculate ground plane dimensions
W_ground = W_patch * 2 + 6 * h;
L_ground = 2 * L_patch + 6 * h;

fprintf('Width of a ground = %f m\nLength of a ground = %f m\n', W_ground, L_ground);
StripWidth = 0.0002;
% Create dielectric substrate
substrate = dielectric('Name', 'FR4', 'EpsilonR', er, 'Thickness', h);
offset1=0.002113;
offset2= 0;
feedOffsetX=0.0021;
feedOffsetY=0;
% insetpatch = patchMicrostripInsetfed(Length=L_patch, Height=35*10^(-6), GroundPlaneLength=L_ground, GroundPlaneWidth=W_ground,Substrate=substrate,StripLineWidth=StripWidth,Conductor=metal("Copper"),FeedOffset=[offset1 offset2]);
% insetpatch = patchMicrostrip(Length=L_patch, Height=35*10^(-6), GroundPlaneLength=L_ground, GroundPlaneWidth=W_ground,Substrate=substrate,StripLineWidth=StripWidth,Conductor=metal("Copper"),FeedOffset=[offset1 offset2]);
patchAnt = patchMicrostrip('Length', L_patch, 'Width', W_patch, ...
    'GroundPlaneLength', L_ground, 'GroundPlaneWidth', W_ground, ...
    'Substrate', substrate, 'Conductor', metal('Copper'), ...
    'FeedOffset', [feedOffsetX, feedOffsetY]);

% show(insetpatch);
show(patchAnt);
% Define RL, range a little wider th
freqRange = linspace(f * 0.95, f * 1.05, 8); % Zakres częstotliwości od 80% do 120% f
RL = returnLoss(patchAnt, freqRange, 50); % Obliczanie RL z impedancją 50 Ohm

% Wykres Return Loss
figure;
plot(freqRange / 1e9, RL); % Częstotliwość w GHz
xlabel('Frequency (GHz)');
ylabel('Return Loss (dB)');
grid on;
title('Return Loss of Microstrip Patch Antenna');
%% 