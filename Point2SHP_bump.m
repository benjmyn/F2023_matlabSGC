
function Output = Point2SHP_bump(P1, P2, P3, bump)

clc

[x1 y1 z1] = deal(P1(1),P1(2),P1(3));
[x2 y2 z2] = deal(P2(1),P2(2),P2(3));
[x3 y3 z3] = deal(P3(1),P3(2),P3(3));

S1 = -P1+P3;
S2 = -P2+P3;
%S3 = P3-P4;

[u1, v1, w1] = deal( S1(1), S1(2), S1(3) );
[u2, v2, w2] = deal( S2(1), S2(2), S2(3) );

R1 = norm(S1);
%sqrt(u1^2 + v1^2 + w1^2)
R2 = norm(S2);



%whp = zhp - z1;
whp = z3 + bump - z1 ;

c1 = R1^2 - whp^2;
%c1 = u1^2 + v1^2;
%c2 = (u1^2) + (v1^2) - (2*u2*u1) - (2*v2*v1);
c2 = c1 - 2*u2*u1 - 2*v2*v1;
%c2 = R2^2 - (u2^2 + v2^2 + w2^2) - whp^2 + 2*w2*whp

A = (-u2 / v2)^2 + 1;
B = 2*(-u2/v2) * (c1-c2) / (2*v2);
C = ( (c1-c2)/(2*v2) )^2 - c1;

x = roots([A B C]) + x1;
y = (-u2/v2)*roots([A B C]) + (c1-c2) / (2*v2) + y1;
z = whp+z1;

c1-c2
2*u2*u1 + 2*v2*v1


[x(2) y(2) z]
[x3,y3,z3]
R1 - sqrt( (x(2)-x1)^2 + (y(2)-y1)^2 + (z-z1)^2)
R2 - sqrt( (x(2)-x2)^2 + (y(2)-y2)^2 + (z-z2)^2)


end