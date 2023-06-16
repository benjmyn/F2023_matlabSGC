
function Output = Point3S(P1, P2, P3, P4, P5)

% ForUp, AftUp, OutUp, OutLoStatic, OutLoBump

clc

[x1 x2 x3 x4 x5] = deal(P1(1),P2(1),P3(1),P4(1),P5(1));
[y1 y2 y3 y4 y5] = deal(P1(2),P2(2),P3(2),P4(2),P5(2));
[z1 z2 z3 z4 z5] = deal(P1(3),P2(3),P3(3),P4(3),P5(3));

% Three static spherical radii (R1 = S1, etc.)
R1 = norm(P1-P3);
R2 = norm(P2-P3);
R3 = norm(P4-P3);

% P1 = S1-S2 
% P2 = S1-S3
% Isolating for X

% Constant component in P1, P2
L1 = (R2^2 - R1^2) + (x1^2 - x2^2) + (y1^2 - y2^2) + (z1^2 - z2^2);
L2 = (R3^2 - R1^2) + (x1^2 - x5^2) + (y1^2 - y5^2) + (z1^2 - z5^2);

% Constant Numerator/Denominator for Y
By_N = L1/(z2-z1) - L2/(z5-z1);
By_D = (y2-y1)/(z2-z1) - (y1-y5)/(z5-z1);

% Constant B for Y
By = By_N / (2*By_D);

% Constant A for Y(x) (Ax+B)
Ay_N = (x2-x1)/(z2-z1) - (x1-x5)/(z5-z1);
Ay = -Ay_N/By_D;

% Coefficient multiple for Y in Z
cz_1 = (y2-y1)/(z2-z1);

Bz_1 = L1/(2*(z2-z1));
Bz_2 = cz_1 * By;
Bz = Bz_1 + Bz_2;

Az_1 = (x2-x1)/(z2-z1);
Az_2 = cz_1 * Ay;
Az = Az_1 + Az_2;

A = 1 + Ay^2 + Az^2;
%B = 2*Ay*By + 2*Az*Bz - 2*(x1 + y1*Ay + z1*Az);
B = 2*Ay*By + 2*Az*Bz - 2*(x2 + y2*Ay + z2*Az);
%C = By^2 + Bz^2 + x1^2 + y1^2 + z1^2 - 2*(y1*By + z1*Bz) - R1^2;
C = By^2 + Bz^2 + x2^2 + y2^2 + z2^2 - 2*(y2*By + z2*Bz) - R2^2;

X = roots([A B C])
Y = Ay*roots([A B C]) + By
Z = Az*roots([A B C]) + Bz

norm([X(1) Y(1) Z(1)] - [x1 y1 z1]) - R1
norm([X(1) Y(1) Z(1)] - [x2 y2 z2]) - R2
norm([X(1) Y(1) Z(1)] - [x5 y5 z5]) - R3


end