
clc, clear
format default
testoption = 3; % 1 - Roll, 2 - Pitch, 3 - Heave
bump = +25;
droop = -25;
iterations = 200;
bumpi = bump/iterations;
heaverange = droop:bumpi:bump;
plotyesorno = true;


%
% Car Dimensions
%

frontperc = 46/100; % Front % Weight
t = 1194; % Track Width (mm)
l = 1536; % Wheelbase (mm)
a = (1-frontperc)*l;
b = frontperc*l;
CG = [0, a, 300];

h = CG(3);

W = 500; % Total Car Weight (lbs)
W_F = W * b/l;
W_R = W * a/l;

W_FL = W_F/2;
W_FR = W_F/2;
W_RL = W_R/2;
W_RR = W_R/2;

W_mat = [W_FL, W_FR, W_RL, W_RR, W];


%
% Corner Weight Approximation
%

if testoption == 1
    % Assumes given roll center
    Ax = input('Input lateral Gs (pos = left turn): ');
    deltaW_F = h*W_F*Ax/t;
    deltaW_R = h*W_R*Ax/t;
    deltaW_mat = [-deltaW_F, deltaW_F, -deltaW_R, deltaW_R, 0];
    W_mat = W_mat + deltaW_mat

    rollopt = 1;
    pitchopt = 0;

end

if testoption == 2
    % Assumes no antipitch
    Ay = input('Input longitudinal Gs (pos = accel): ');
    deltaW = h*W*Ay/t
    deltaW_mat = [-deltaW/2, -deltaW/2, deltaW/2, deltaW/2, 0];
    W_mat = W_mat + deltaW_mat

    rollopt = 0;
    pitchopt = 1;
end


if testoption == 3
    % Assumes bump G's in addition to static 1G
    heave = input('Input bump Gs: ');
    W_mat = (heave+1)*W_mat 

    rollopt = 1;
    pitchopt = 1;
end


%
% Suspension Dimensions
%

front_lo_fore_static = [148,120,128];
front_lo_aft_static = [148,-120,135];
front_lo_out_static = [515,22,110];

front_up_fore_static = [148,120,247];
front_up_aft_static = [148,-120,244];
front_up_out_static = [489,10,290];

front_tie_out_static = [474,-80,200];
front_tie_in_static = [135,-80,188];

front_pull_out_static = [370,0,260];
front_pull_in_static = [147 0 96];
front_pull_in_OG = front_pull_in_static;

zbarx = 120; % 120
zbarz = 140; % 140
front_zbar_aft_static = [zbarx,100,zbarz];
front_zbar_fore_static = [zbarx,-100,zbarz];

front_zbar_MR = [];
front_deflectionfull = [];


%
% Heave Position Calculations
%

if droop ~= 0

    lo_out_bump = Point2SHP(front_lo_fore_static, front_lo_aft_static, front_lo_out_static, front_lo_out_static(3)+droop);
    up_out_bump = Point3S(1, front_up_fore_static, front_up_fore_static, front_up_aft_static, front_up_aft_static, front_lo_out_static, lo_out_bump, front_up_out_static);
    tie_out_bump = Point3S(1, front_tie_in_static, front_tie_in_static, front_up_out_static, up_out_bump, front_lo_out_static, lo_out_bump, front_tie_out_static);
    pull_out_bump = Point3S(1, front_up_fore_static, front_up_fore_static, front_up_aft_static, front_up_aft_static, front_up_out_static, up_out_bump, front_pull_out_static);
    pull_in_bump = Point3S(1, front_pull_out_static, pull_out_bump, front_zbar_aft_static, front_zbar_aft_static, front_zbar_fore_static, front_zbar_fore_static, front_pull_in_static);
    bump_steer = Angle2P(front_tie_out_static, front_up_out_static, front_lo_out_static, tie_out_bump, up_out_bump, lo_out_bump);
    %deflection = norm(pull_in_bump - pull_in_static);
    %deflectionfull = [deflectionfull, norm(pull_in_bump - pull_in_OG)];
    %zbar_MR = [zbar_MR, deflection/bumpi];
    
    front_lo_out_static = lo_out_bump;
    front_up_out_static = up_out_bump;
    front_tie_out_static = tie_out_bump;
    front_pull_out_static = pull_out_bump;
    front_pull_in_static = pull_in_bump;


end

for index = heaverange

    lo_out_bump = Point2SHP(front_lo_fore_static, front_lo_aft_static, front_lo_out_static, front_lo_out_static(3)+bumpi);
    up_out_bump = Point3S(1, front_up_fore_static, front_up_fore_static, front_up_aft_static, front_up_aft_static, front_lo_out_static, lo_out_bump, front_up_out_static);
    tie_out_bump = Point3S(1, front_tie_in_static, front_tie_in_static, front_up_out_static, up_out_bump, front_lo_out_static, lo_out_bump, front_tie_out_static);
    pull_out_bump = Point3S(1, front_up_fore_static, front_up_fore_static, front_up_aft_static, front_up_aft_static, front_up_out_static, up_out_bump, front_pull_out_static);
    pull_in_bump = Point3S(1, front_pull_out_static, pull_out_bump, front_zbar_aft_static, front_zbar_aft_static, front_zbar_fore_static, front_zbar_fore_static, front_pull_in_static);
    bump_steer = Angle2P(front_tie_out_static, front_up_out_static, front_lo_out_static, tie_out_bump, up_out_bump, lo_out_bump);
    deflection = norm(pull_in_bump - front_pull_in_static);
    front_deflectionfull = [front_deflectionfull, norm(pull_in_bump - front_pull_in_OG)];
    front_zbar_MR = [front_zbar_MR, deflection/bumpi];
    
    front_lo_out_static = lo_out_bump;
    front_up_out_static = up_out_bump;
    front_tie_out_static = tie_out_bump;
    front_pull_out_static = pull_out_bump;
    front_pull_in_static = pull_in_bump;
%index


end

%plot(heaverange, front_deflectionfull, 'o')


%% 


%
% Spring Dimensions
%

G = 77000; % 77GPa -> MPa (N/mm2)
L = l; % Bar length (mm)
R = norm([front_zbar_fore_static(1) 0 front_zbar_fore_static(3)] - [front_pull_in_static(1) 0 front_pull_in_static(3)]); % (mm)
D = 25; % Outer diameter (mm)
d = 23; % Inner diameter (mm)

E = 200000; % 210GPa -> MPa (N/mm2)
leafB = 50;
leafH = 2.5;
leafIx = leafB*leafH^3;
leafL = zbarx

FperYpitch = sign(heaverange).*front_deflectionfull*E*leafIx / (leafL^3); % Need to alter for side-specific pitch
FperYroll = sign(heaverange).*front_deflectionfull*pi*G*(D^4 - d^4) / (32*R^2*L);
F_static = 0.5*W_F;

lbperY = (FperYroll*rollopt + FperYpitch*pitchopt).*front_zbar_MR/4.44822 + F_static;

if plotyesorno
    plot(lbperY, heaverange); % mm per lbs bump
    ylabel('Wheel Motion (mm)', 'FontSize',13)
    xlabel('Wheel Force (lbs)', 'FontSize',13)
    title('Wheel Motion vs. Force', 'FontSize',13)
end

wheel_bump_output_L = interp1(lbperY, heaverange, W_mat(1), 'makima');
wheel_bump_output_R = interp1(lbperY, heaverange, W_mat(2), 'makima');
[wheel_bump_output_L, wheel_bump_output_R]

rolldeg = atan((wheel_bump_output_R - wheel_bump_output_L) / t) * 180/pi
rollheave = (wheel_bump_output_R + wheel_bump_output_L)/2
center_wheelrate_N_mm = (lbperY(iterations/2+1) - lbperY(iterations/2)) / bumpi * 4.44822
bump_wheelrate_secant_N_mm = (lbperY(iterations) - lbperY(iterations/2)) / (bumpi*iterations/2) * 4.44822;
droop_wheelrate_secant_N_mm = (lbperY(iterations/2) - lbperY(1)) / (bumpi*iterations/2) * 4.44822;

% 4.44822 * W_mat
