
function y = unit(x)
y = zeros(size(x));
y(x>0) = 1;
end