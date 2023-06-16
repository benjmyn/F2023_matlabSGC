

function Output = Point3S_tie(P1, P2, P3, P4, P5, P6)

% tie_in_static, tie_out_static, up_out_static, up_out_bump, lo_out_static, lo_out_bump


[x1, x2, x3] = deal(P1(1),P4(1),P6(1));
[y1, y2, y3] = deal(P1(2),P4(2),P6(2));
[z1, z2, z3] = deal(P1(3),P4(3),P6(3));

% Three static spherical radii (R1 = S1, etc.)
R1 = norm(P1-P2);
R2 = norm(P3-P2);
R3 = norm(P5-P2);

u2 = x2-x1;
v2 = y2-y1;
w2 = z2-z1;

u3 = x3-x1;
v3 = y3-y1;
w3 = z3-z1;

% Test Variables
%u3 = x4-x1;
%v3 = y4-y1;
%w3 = z4-z1;


c1 = R1^2;
c2 = R2^2 - (u2^2 + v2^2 + w2^2);
c3 = R3^2 - (u3^2 + v3^2 + w3^2);

c4 = 0.5*(c1-c2);
c5 = 0.5*(c1-c3);

a1 = w3*u2 - w2*u3;
a2 = w3*v2 - w2*v3;
a3 = w3*c4 - w2*c5;
a4 = a3/a2;
a5 = -a1/a2;

b1 = (c4 - a4*v2) / w2;
b2 = -(u2 + a5*v2) / w2;

A = 1 + a5^2 + b2^2;
B = 2*(a4*a5 + b1*b2 - (1+a5^2+b2^2)*x1);
C = -2*(a4*a5 + b1*b2)*x1 + a4^2 + b1^2 - R1^2 + (1+a5^2+b2^2)*(x1^2);

x = roots([A B C]);
x = x(2);
y = a4 + a5*x - a5*x1 + y1;
z = b1 + b2*x - b2*x1 + z1;

Output = [x y z];

end