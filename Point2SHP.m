
function Output = Point2SHP(P1, P2, P3, zhp)

%clc

S1 = P1-P3;
S2 = P2-P3;

x1 = P1(1);
x2 = P2(1);
%x3 = P3(1);
y1 = P1(2);
y2 = P2(2);
%y3 = P3(2);
z1 = P1(3);
z2 = P2(3);
z = zhp;

R1 = norm(S1);
R2 = norm(S2);

%u = S1(1);
%v = S1(2);
%w = zhp - P1(3);
%u2 = S2(1);
%v2 = S2(2);
%w2 = S2(3);
%R1 = norm([u v w])

C = (x1^2 - x2^2) + (y1^2 - y2^2) + (z1^2 - z2^2) + (R2^2 - R1^2);
%B = (C/2 - (z1-z2)*z) / (y1-y2)
%M = (x1-x2) / (y1-y2)

Bx = (C/2 - (z1-z2)*z) / (y1-y2);
Mx = (x1-x2) / (y1-y2);
By = (C/2 - (z1-z2)*z) / (x1-x2);
My = (y1-y2) / (x1-x2);

if Bx == Inf || Mx == Inf
    polyA = (1+My^2);
    polyB = 2*(-y1 + x1*My - By*My);
    polyC = y1^2 + By^2 + x1^2 - 2*By*x1 + z^2 - 2*z*z1 + z1^2 - R1^2;

    y = roots([polyA polyB polyC]);
    x = By - My*y;

else    
    polyA = (1+Mx^2);
    polyB = 2*(-x1 + y1*Mx - Bx*Mx);
    polyC = x1^2 + Bx^2 + y1^2 - 2*Bx*y1 + z^2 - 2*z*z1 + z1^2 - R1^2;

    x = roots([polyA polyB polyC]);
    y = Bx - Mx*x;
    
end
    z ;

% Radius consistency check
[x(1) y(1) z];
norm([x(1) y(1) z] - P1) - R1;
norm([x(1) y(1) z] - P2) - R2;

if norm(P3 - [x(1) y(1) z]) < norm(P3 - [x(2) y(2) z])
    Output = [x(1) y(1) z];
else
    Output = [x(2) y(2) z];

end

end 