
function q = trilateration( p, r )
% Inputs:
%   p       3x3 matrix where the columns are the xyz
%           locations of the sphere centers
%   r       3x1 vector of the sphere radii
%
% Outputs:
%   q       3x1 vector of the (positive) point of
%           intersection of the three spheres. If
%           imaginary, then no such point exists

p0 = p(:,1);
ex = unit( p(:,2) - p(:,1) );
i = ex' * ( p(:,3) - p(:,1) );
ey = unit( p(:,3) - p(:,1) - i * ex );
ez = cross( ex, ey );
T = [ ex, ey, ez ]

t = T' * ( p - repmat( p0, 1, 3 ) );

d = t(1,2);
j = t(2,3);

x = ( r(1)^2 - r(2)^2 + d^2 ) / (2*d);
y = ( r(1)^2 - r(3)^2 + i^2 + j^2 ) / (2*j) - i/j * x;
z = sqrt( r(1)^2 - x^2 - y^2 );

q = T * [ x; y; z ] + p0;

end