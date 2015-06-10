function [estimatedLocation, totalError] = trilaterate_beck(anchors, distances)
%------------------------------------------------------------------------------
% Trilaterates the location of a point from distances to a fixed set of
% anchors. Uses algorithm described by Beck et al.
% 
% INPUT : anchors           ... anchor locations - if we have M anchors in D
%                               dimensions, a is an M by D matrix
%         distances         ... distances between anchors and the point of
%                               interest
%
% OUTPUT: estimatedLocation ... estimated location (D by 1)
%         totalError        ... sum of absolute distance errors from the 
%                               estimated point to the anchors
%------------------------------------------------------------------------------

d = size(anchors, 2);
m = length(distances);

A = [-2 * anchors, ones(m, 1)];

b = distances.^2 - sum(anchors.^2, 2);

D = [eye(d), zeros(d, 1); zeros(1, d), 0];

f = [zeros(d, 1); -0.5];

y   = @(lambda) (A'*A + lambda * D) \ (A'*b - lambda * f); 
phi = @(lambda) y(lambda)' * D * y(lambda) + 2 * f' * y(lambda);

eigDAA  = eig(D, A'*A);
lambda1 = eigDAA(end);

a1 = -1/lambda1; 
a2 = 1000;

epsAbs  = 1e-5;
epsStep = 1e-5;

warning off;
while (a2 - a1 >= epsStep || ( abs( phi(a1) ) >= epsAbs && abs( phi(a2) )  >= epsAbs ) )
    c = (a1 + a2)/2;
    if ( phi(c) == 0 )
       break;
    elseif ( phi(a1)*phi(c) < 0 )
       a2 = c;
    else
       a1 = c;
    end
end
warning on;

estimatedLocation      = y(c);
estimatedLocation(end) = [];

totalError = sum(abs(sqrt(sum(bsxfun(@minus, anchors', estimatedLocation).^2)) - distances(:)'));
