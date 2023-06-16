
clc, clear
option = 2; % 1 - Lateral, 2 - Longitudinal, 3 - Heave


frontperc = 46/100;
t = 1194; % mm
l = 1536; % mm
a = (1-frontperc)*l;
b = frontperc*l;
CG = [0, a, 300]

h = CG(3);

W = 500; % lbs

W_F = W * b/l;
W_R = W * a/l;

W_FL = W_F/2;
W_FR = W_F/2;
W_RL = W_R/2;
W_RR = W_R/2;

W_mat = [W_FL, W_FR, W_RL, W_RR, W]



if option == 1
    % Assumes given roll center
    Ax = input('Input lateral Gs (pos = left turn): ');
    deltaW_F = h*W_F*Ax/t;
    deltaW_R = h*W_R*Ax/t;
    deltaW_mat = [-deltaW_F, deltaW_F, -deltaW_R, deltaW_R, 0];
    W_mat = W_mat + deltaW_mat

end

if option == 2
    % Assumes no antipitch
    Ay = input('Input longitudinal Gs (pos = accel): ');
    deltaW = h*W*Ay/t
    deltaW_mat = [-deltaW/2, -deltaW/2, deltaW/2, deltaW/2, 0];
    W_mat = W_mat + deltaW_mat
end


if option == 3
    % Assumes bump G's in addition to static 1G
    heave = input('Input bump Gs: ');
    W_mat = (heave+1)*W_mat 
end


