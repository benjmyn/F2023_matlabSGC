
clc, clear

lo_fore_static = [148,120,128];
lo_aft_static = [148,-120,135];
lo_out_static = [515,22,110];

up_fore_static = [148,120,247];
up_aft_static = [148,-120,244];
up_out_static = [489,10,290];

tie_out_static = [474,-80,200];
tie_in_static = [135,-80,188];

%pull_out_static = [450,0,275];
pull_out_static = [370,0,260];
pull_in_static = [147 0 96];

%zbar_aft_static = [107,100,126];
zbar_aft_static = [120,100,140];
%zbar_fore_static = [107,-100,126];
zbar_fore_static = [120,-100,140];

bump = +25;

%lo_fore_static = [110,140,130];
%lo_aft_static = [-120,150,250];
%lo_out_static = [10,500,300];
%
%up_fore_static = [100,180,260];
%up_aft_static = [-150,170,360];
%up_out_static = [0 460 380];
%
%tie_in_static = [-100 150 300];
%tie_out_static = [-100 500 350];




lo_out_bump = Point2SHP(lo_fore_static, lo_aft_static, lo_out_static, lo_out_static(3)+bump)

%up_out_bump = Point3S2(up_fore_static, up_aft_static, up_out_static, lo_out_static, lo_out_bump)
up_out_bump = Point3S(1, up_fore_static, up_fore_static, up_aft_static, up_aft_static, lo_out_static, lo_out_bump, up_out_static)

%tie_out_bump = Point3S_tie(tie_in_static, tie_out_static, up_out_static, up_out_bump, lo_out_static, lo_out_bump)
tie_out_bump = Point3S(1, tie_in_static, tie_in_static, up_out_static, up_out_bump, lo_out_static, lo_out_bump, tie_out_static)

pull_out_bump = Point3S(1, up_fore_static, up_fore_static, up_aft_static, up_aft_static, up_out_static, up_out_bump, pull_out_static)

pull_in_bump = Point3S(1, pull_out_static, pull_out_bump, zbar_aft_static, zbar_aft_static, zbar_fore_static, zbar_fore_static, pull_in_static)

%bump_steer = Angle2P(tie_out_static, up_out_static, lo_out_static, tie_out_bump, up_out_bump, lo_out_bump)
%deflection = norm(pull_in_bump - pull_in_static)
%simple_zbar_MR = deflection/bump
