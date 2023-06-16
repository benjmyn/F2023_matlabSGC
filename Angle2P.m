
function Output = Angle2P(P1, P2, P3, P4, P5, P6)

u2 = P2(1) - P1(1);
u3 = P3(1) - P1(1);
v2 = P2(2) - P1(2);
v3 = P3(2) - P1(2);
w2 = P2(3) - P1(3);
w3 = P3(3) - P1(3);

u5 = P5(1) - P4(1);
u6 = P6(1) - P4(1);
v5 = P5(2) - P4(2);
v6 = P6(2) - P4(2);
w5 = P5(3) - P4(3);
w6 = P6(3) - P4(3);

N1_x = v2*w3 - v3*w2;
N1_y = u3*w2 - u2*w3;
N1_z = u2*v3 - u3*v2;

N2_x = v5*w6 - v6*w5;
N2_y = u6*w5 - u5*w6;
N2_z = u5*v6 - u6*v5;

outtop = abs(N1_x*N2_x + N1_y*N2_y + N1_z*N2_z);
outbot = sqrt(N1_x^2 + N1_y^2 + N1_z^2) * sqrt(N2_x^2 + N2_y^2 + N2_z^2);
Output = radtodeg(acos(outtop/outbot));

end