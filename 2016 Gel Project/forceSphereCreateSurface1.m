% function X=forceSphere(N, vargin)
% Calc Thomson equlibrium on sphere of N points
%
% vx = forceSphere(N)
% vx = forceSphere(N,tol)
%
% Input: N number of points to distribute. tol tolerance.
% Returns: Nx3 array of points on the sphere.
N=50; tol=1e-4;
X=randn(N,3);
k = 0.1; %stepsize
smudge=1e-3; % prevent singularities
radius=1;

% if (nargin>1) tol=vargin(1); else tol=1e-6; end


delta=100;
while (delta>tol)
    delta=0;
    for i=1:N
        dx=ones(N,1)*X(i,:)-X;
        d=sum(dx'.^2)';
        fx=dx./(smudge+d*ones(1,3));
        xold=X(i,:);
        X(i,:)=X(i,:)+k*sum(fx);
        X(i,:)=X(i,:)/norm(X(i,:));
        delta=delta+norm(xold-X(i,:))/N;
    end
end

dt = DelaunayTri(X(:,1),X(:,2),X(:,3));
[tri, nodesSurface] = freeBoundary(dt);
% tr = TriRep(tri, nodesSurface);
% P = incenters(tr);
% fn = faceNormals(tr);





