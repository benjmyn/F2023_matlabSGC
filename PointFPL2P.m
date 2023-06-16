
function Output = PointFPL2P(P1, P2, P3, P4, P5)

clc
% LFore, LAft,
%clc

[x1 y1 z1] = deal(P1(1),P1(2),P1(3));
[x2 y2 z2] = deal(P2(1),P2(2),P2(3));
[x3 y3 z3] = deal(P3(1),P3(2),P3(3));
[x4 y4 z4] = deal(P4(1),P4(2),P4(3));
%[x4 y4 z4]

S1 = P4-P1;
S2 = P4-P2;
S3 = P3-P4;
S4 = P5-P4;


R1 = norm(S1); % Lower Outboard Location Sphere 1
R2 = norm(S2); % Lower Outboard Location Sphere 2
R3 = norm(S3); % Lower Outboard Sphere

[u1, v1, w1] = deal( S1(1), S1(2), S1(3) );
[u2, v2, w2] = deal( S2(1), S2(2), S2(3) );
[u3, v3, w3] = deal( S4(1), S4(2), S4(3) );

c4 = u2*u1 + v2*v1 + w2*w1;
c5 = u3*u1 + v3*v1 + w3*w1;

c1 = R1^2;
c2 = R2^2 - (u2^2 + v2^2 + w2^2);
c3 = R3^2 - (u3^2 + v3^2 + w3^2);
%c4 = (c1-c2)/2;
%c5 = (c1-c3)/2;


a1 = w3*u2 - w2*u3;
a2 = w3*v2 - w2*v3;
a3 = w3*c4 - w2*c5;
a4 = a3/a2;
a5 = -a1/a2;

b1 = (c4 - a4*v2) / w2;
b2 = -(u2 + a5*v2) / w2;

A = (1 + a5^2 + b2^2);
B = 2*(a4*a5 + b1*b2);
C = (a4^2 + b1^2 - R1^2);

outx = roots([A B C]) + x1;
outy = roots([A B C]) * a5 + a4 + y1;
outz = roots([A B C]) * b2 + b1 + z1;

norm([outx(1), outy(1), outz(1)] - P1) - R1
norm([outx(1), outy(1), outz(1)] - P2) - R2
norm([outx(1), outy(1), outz(1)] - P5) - R3


Output = [outx(1), outy(1), outz(1)];

end
