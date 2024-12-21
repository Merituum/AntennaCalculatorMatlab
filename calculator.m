% clear;clc;
% 
% f = input('Insert resonance frequency (f) [Hz]: ');
% er = input('Insert dielectric constant (er): ');
% h = input('Height of dielectric (h) [m]: ');
% c = 3e8; 
% w_line = input('Width of microstrip line (w_line) [m]: ');
% W_patch = c / (2 * f * sqrt((er + 1) / 2));
% fprintf('Width of a patch=%f\n', W_patch);
% 
% er_eff = (er + 1) / 2 + (er - 1) / 2 * (1 + 12 * (h / W_patch))^(-0.5);
% 
% deltaL = 0.412 * h * ((er_eff + 0.3) * ((W_patch / h) + 0.264)) / ...
%          ((er_eff - 0.258) * ((W_patch / h) + 0.8));
% 
% L_patch = (c / (2 * f * sqrt(er_eff))) - 2 * deltaL;
% fprintf('Length of a patch=%f\n', L_patch);
% 
% W_ground = W_patch*2+6*h;
% L_ground = 2*L_patch+6*h;
% 
% fprintf('Width of a ground=%f\n Length of a ground=%f\n',W_ground, L_ground);
% 
% 
% % Create dielectric substrate
% substrate = dielectric('Name', 'FR4', 'EpsilonR', er, 'Thickness', h);
% 
% % Define feed offset for the patch
% feedOffsetX = 0; % Feed offset along the length (L_patch)
% feedOffsetY = -W_patch/4; % Adjust feed position to be within valid range
% 
% % Create patch antenna
% patchAnt = patchMicrostrip('Length', L_patch, 'Width', W_patch, ...
%     'GroundPlaneLength', L_ground, 'GroundPlaneWidth', W_ground, ...
%     'Substrate', substrate, 'Conductor', metal('Copper'), ...
%     'FeedOffset', [feedOffsetX feedOffsetY]);
% 
% % Define microstrip line geometry
% lineLength = L_ground / 2; % Length from ground plane edge to patch
% lineStart = [-lineLength/2 -w_line/2 0]; % Start point of the line
% lineEnd = [-lineLength/2 W_patch/2 0];   % End point on patch edge
% lineWidth = w_line;
% 
% % Add microstrip line to the antenna
% microstripLine = trace(patchAnt, lineStart, lineEnd, 'Width', lineWidth);
% 
% % Display the antenna with microstrip line
% figure;
% show(patchAnt);
% hold on;
% plot3([lineStart(1), lineEnd(1)], [lineStart(2), lineEnd(2)], [lineStart(3), lineEnd(3)], 'r', 'LineWidth', 2);
% hold off;
% title('Microstrip Patch Antenna with Feed Line');
% 
% % Analyze and display radiation pattern
% figure;
% pattern(patchAnt, f);
% title('Radiation Pattern of Microstrip Patch Antenna');

clear; clc;

% Input parameters
% f = input('Insert resonance frequency (f) [Hz]: ');
% er = input('Insert dielectric constant (er): ');
% h = input('Height of dielectric (h) [m]: ');
% w_line = input('Width of microstrip line (w_line) [m]: ');
c = 3e8;
f=3.4*10^9;
er=4.3;
h=0.0008;
w=0.002;
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
offset1=0.002113
offset2= 0
insetpatch = patchMicrostripInsetfed(Length=L_patch, Height=35*10^(-6), GroundPlaneLength=L_ground, GroundPlaneWidth=W_ground,Substrate=substrate,StripLineWidth=StripWidth,Conductor=metal("Copper"),FeedOffset=[offset1 offset2]);
% insetpatch = patchMicrostrip(Length=L_patch, Height=35*10^(-6), GroundPlaneLength=L_ground, GroundPlaneWidth=W_ground,Substrate=substrate,StripLineWidth=StripWidth,Conductor=metal("Copper"),FeedOffset=[offset1 offset2]);

show(insetpatch);

RL = returnLoss(insetpatch,f,50);
show(RL);
%% 