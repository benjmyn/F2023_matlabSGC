
clc, clear
bump = +25;
droop = -25; % <= 0
iterations = 200;
bumpi = bump/iterations;
%heaverange = bumpi:bumpi:bump;
heaverange = droop:bumpi:bump;

wheel_force_input_L = 62; % lbs
wheel_force_input_R = 188;
track = 1194;

plotyesorno = true;

lo_fore_static = [148,120,128];
lo_aft_static = [148,-120,135];
lo_out_static = [515,22,110];

up_fore_static = [148,120,247];
up_aft_static = [148,-120,244];
up_out_static = [489,10,290];

tie_out_static = [474,-80,200];
tie_in_static = [135,-80,188];

pull_out_static = [370,0,260];
pull_in_static = [147 0 96];
pull_in_OG = pull_in_static;

zbarx = 120; % 120
zbarz = 140; % 140
zbar_aft_static = [zbarx,100,zbarz];
zbar_fore_static = [zbarx,-100,zbarz];

zbar_MR = [];
deflectionfull = [];

if droop ~= 0

    lo_out_bump = Point2SHP(lo_fore_static, lo_aft_static, lo_out_static, lo_out_static(3)+droop);
    up_out_bump = Point3S(1, up_fore_static, up_fore_static, up_aft_static, up_aft_static, lo_out_static, lo_out_bump, up_out_static);
    tie_out_bump = Point3S(1, tie_in_static, tie_in_static, up_out_static, up_out_bump, lo_out_static, lo_out_bump, tie_out_static);
    pull_out_bump = Point3S(1, up_fore_static, up_fore_static, up_aft_static, up_aft_static, up_out_static, up_out_bump, pull_out_static);
    pull_in_bump = Point3S(1, pull_out_static, pull_out_bump, zbar_aft_static, zbar_aft_static, zbar_fore_static, zbar_fore_static, pull_in_static);
    bump_steer = Angle2P(tie_out_static, up_out_static, lo_out_static, tie_out_bump, up_out_bump, lo_out_bump);
    %deflection = norm(pull_in_bump - pull_in_static);
    %deflectionfull = [deflectionfull, norm(pull_in_bump - pull_in_OG)];
    %zbar_MR = [zbar_MR, deflection/bumpi];
    
    lo_out_static = lo_out_bump;
    up_out_static = up_out_bump;
    tie_out_static = tie_out_bump;
    pull_out_static = pull_out_bump;
    pull_in_static = pull_in_bump;


end

for index = heaverange

    lo_out_bump = Point2SHP(lo_fore_static, lo_aft_static, lo_out_static, lo_out_static(3)+bumpi);
    up_out_bump = Point3S(1, up_fore_static, up_fore_static, up_aft_static, up_aft_static, lo_out_static, lo_out_bump, up_out_static);
    tie_out_bump = Point3S(1, tie_in_static, tie_in_static, up_out_static, up_out_bump, lo_out_static, lo_out_bump, tie_out_static);
    pull_out_bump = Point3S(1, up_fore_static, up_fore_static, up_aft_static, up_aft_static, up_out_static, up_out_bump, pull_out_static);
    pull_in_bump = Point3S(1, pull_out_static, pull_out_bump, zbar_aft_static, zbar_aft_static, zbar_fore_static, zbar_fore_static, pull_in_static);
    bump_steer = Angle2P(tie_out_static, up_out_static, lo_out_static, tie_out_bump, up_out_bump, lo_out_bump);
    deflection = norm(pull_in_bump - pull_in_static);
    deflectionfull = [deflectionfull, norm(pull_in_bump - pull_in_OG)];
    zbar_MR = [zbar_MR, deflection/bumpi];
    
    lo_out_static = lo_out_bump;
    up_out_static = up_out_bump;
    tie_out_static = tie_out_bump;
    pull_out_static = pull_out_bump;
    pull_in_static = pull_in_bump;
%index


end

lo_out_bump;
up_out_bump;
tie_out_bump;
pull_out_bump;
pull_in_bump;

G = 77000; % 77GPa -> MPa (N/mm2)
L = 1500; % Bar length (mm)
R = norm([zbar_fore_static(1) 0 zbar_fore_static(3)] - [pull_in_static(1) 0 pull_in_static(3)]); % (mm)
D = 25; % Outer diameter (mm)
d = 22.5; % Inner diameter (mm)

FperY = sign(heaverange).*deflectionfull*pi*G*(D^4 - d^4) / (32*R^2*L);
F_static = 1*125;

%plot(bumpi:bumpi:bump, zbar_MR)
%plot(bumpi:bumpi:bump, deflectionfull)

if plotyesorno
    plot(FperY.*zbar_MR/4.44822 + F_static, heaverange); % mm per lbs bump
    ylabel('Wheel Motion (mm)', 'FontSize',13)
    xlabel('Wheel Force (lbs)', 'FontSize',13)
    title('Wheel Motion vs. Force', 'FontSize',13)
end

wheel_bump_output_L = interp1(FperY.*zbar_MR/4.44822 + F_static, heaverange, wheel_force_input_L, 'makima')
wheel_bump_output_R = interp1(FperY.*zbar_MR/4.44822 + F_static, heaverange, wheel_force_input_R, 'makima')

rolldeg = atan((wheel_bump_output_R - wheel_bump_output_L) / track) * 180/pi
